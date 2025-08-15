<?php

namespace App\Scout;

use Laravel\Scout\Builder;
use Laravel\Scout\Engines\Engine;
use Typesense\Client;
use Typesense\Exceptions\TypesenseClientError;
use Typesense\Exceptions\ObjectNotFound;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Collection;
use Illuminate\Support\LazyCollection;

class TypesenseEngine extends Engine
{
    protected $typesense;

    public function __construct(Client $typesense)
    {
        $this->typesense = $typesense;
    }

    public function update($models)
    {
        if ($models->isEmpty()) {
            return;
        }

        $model = $models->first();
        $collectionName = $model->searchableAs();

        // Create collection if it doesn't exist
        $this->createCollectionIfNotExists($model);

        // Index documents
        $documents = $models->map(function ($model) {
            $array = $model->toSearchableArray();
            
            if (empty($array)) {
                return null;
            }

            return array_merge(['id' => $model->getScoutKey()], $array);
        })->filter()->values()->all();

        if (!empty($documents)) {
            try {
                $this->typesense->collections[$collectionName]->documents->import($documents, ['action' => 'upsert']);
            } catch (TypesenseClientError $e) {
                // Handle error gracefully
                logger()->error("Typesense indexing error: " . $e->getMessage());
            }
        }
    }

    public function delete($models)
    {
        if ($models->isEmpty()) {
            return;
        }

        $model = $models->first();
        $collectionName = $model->searchableAs();

        $models->each(function ($model) use ($collectionName) {
            try {
                $this->typesense->collections[$collectionName]->documents[$model->getScoutKey()]->delete();
            } catch (TypesenseClientError $e) {
                // Document might not exist, ignore
            }
        });
    }

    public function search(Builder $builder)
    {
        return $this->performSearch($builder, [
            'per_page' => $builder->limit ?: 20,
            'page' => 1,
        ]);
    }

    public function paginate(Builder $builder, $perPage, $page)
    {
        return $this->performSearch($builder, [
            'per_page' => $perPage,
            'page' => $page,
        ]);
    }

    protected function performSearch(Builder $builder, array $options = [])
    {
        $searchParameters = [
            'q' => $builder->query ?: '*',
            'query_by' => $this->getSearchableFields($builder->model),
            'per_page' => $options['per_page'] ?? 20,
            'page' => $options['page'] ?? 1,
        ];

        // Add filters
        if (!empty($builder->wheres)) {
            $filters = collect($builder->wheres)->map(function ($value, $key) {
                return "{$key}:={$value}";
            })->implode(' && ');
            
            $searchParameters['filter_by'] = $filters;
        }

        try {
            $results = $this->typesense->collections[$builder->model->searchableAs()]->documents->search($searchParameters);
            
            return [
                'results' => collect($results['hits'] ?? [])->pluck('document'),
                'total' => $results['found'] ?? 0,
            ];
        } catch (TypesenseClientError $e) {
            logger()->error("Typesense search error: " . $e->getMessage());
            return ['results' => collect(), 'total' => 0];
        }
    }

    public function mapIds($results)
    {
        return $results['results']->pluck('id');
    }

    public function map(Builder $builder, $results, $model)
    {
        if ($results['total'] === 0) {
            return $model->newCollection();
        }

        $objectIds = collect($results['results'])->pluck('id');
        
        $models = $model->getScoutModelsByIds(
            $builder, $objectIds->all()
        )->keyBy(function ($model) {
            return $model->getScoutKey();
        });

        return collect($results['results'])->map(function ($hit) use ($models) {
            $key = $hit['id'];
            
            if (isset($models[$key])) {
                return $models[$key];
            }
        })->filter()->values();
    }

    public function getTotalCount($results)
    {
        return $results['total'];
    }

    public function flush($model)
    {
        try {
            $this->typesense->collections[$model->searchableAs()]->delete();
        } catch (TypesenseClientError $e) {
            // Collection might not exist, ignore
        }
    }

    public function createIndex($name, array $options = [])
    {
        // This method is called by Scout but we handle collection creation in createCollectionIfNotExists
    }

    public function deleteIndex($name)
    {
        try {
            $this->typesense->collections[$name]->delete();
        } catch (TypesenseClientError $e) {
            // Collection might not exist, ignore
        }
    }

    protected function createCollectionIfNotExists(Model $model)
    {
        $collectionName = $model->searchableAs();
        
        try {
            // Try to retrieve the collection
            $this->typesense->collections[$collectionName]->retrieve();
            logger()->info("Collection '{$collectionName}' already exists");
        } catch (ObjectNotFound $e) {
            // Collection doesn't exist, create it
            $schema = [
                'name' => $collectionName,
                'fields' => $this->getCollectionFields($model),
            ];
            
            logger()->info("Creating collection '{$collectionName}' with schema", $schema);
            $result = $this->typesense->collections->create($schema);
            logger()->info("Collection created successfully", $result);
        } catch (TypesenseClientError $e) {
            logger()->error("Error checking collection: " . $e->getMessage());
            throw $e;
        } catch (\Exception $e) {
            logger()->error("Unexpected error in createCollectionIfNotExists: " . $e->getMessage());
            throw $e;
        }
    }

    protected function getCollectionFields(Model $model)
    {
        // Get sample searchable array to determine field types
        $searchableArray = $model->toSearchableArray();
        
        $fields = [
            ['name' => 'id', 'type' => 'string'],
        ];
        
        foreach ($searchableArray as $key => $value) {
            $type = 'string'; // Default type
            
            if (is_int($value)) {
                $type = 'int32';
            } elseif (is_float($value)) {
                $type = 'float';
            } elseif (is_bool($value)) {
                $type = 'bool';
            }
            
            $fields[] = [
                'name' => $key,
                'type' => $type,
                'optional' => true,
            ];
        }
        
        return $fields;
    }

    protected function getSearchableFields(Model $model)
    {
        // Get all searchable fields for query_by parameter
        $searchableArray = $model->toSearchableArray();
        $stringFields = [];
        
        foreach ($searchableArray as $key => $value) {
            // Skip 'id' field as it cannot be used in query_by
            if ($key !== 'id' && is_string($value)) {
                $stringFields[] = $key;
            }
        }
        
        // Fallback to at least one string field if none found
        if (empty($stringFields)) {
            // Find first string field that's not 'id'
            foreach ($searchableArray as $key => $value) {
                if ($key !== 'id' && (is_string($value) || is_null($value))) {
                    $stringFields[] = $key;
                    break;
                }
            }
        }
        
        return empty($stringFields) ? 'title' : implode(',', $stringFields);
    }

    public function lazyMap(Builder $builder, $results, $model)
    {
        if ($results['total'] === 0) {
            return LazyCollection::make($model->newCollection());
        }

        $objectIds = collect($results['results'])->pluck('id');
        
        $models = $model->getScoutModelsByIds(
            $builder, $objectIds->all()
        )->keyBy(function ($model) {
            return $model->getScoutKey();
        });

        return new LazyCollection(function () use ($results, $models) {
            foreach ($results['results'] as $hit) {
                $key = $hit['id'];
                
                if (isset($models[$key])) {
                    yield $models[$key];
                }
            }
        });
    }
}
