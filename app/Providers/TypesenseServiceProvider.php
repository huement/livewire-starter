<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Scout\TypesenseEngine;
use Typesense\Client;

class TypesenseServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->app->singleton(Client::class, function ($app) {
            return new Client([
                'nodes' => [
                    [
                        'host' => config('scout.typesense.client-settings.nodes.0.host', 'localhost'),
                        'port' => config('scout.typesense.client-settings.nodes.0.port', '8108'),
                        'protocol' => config('scout.typesense.client-settings.nodes.0.protocol', 'http'),
                    ],
                ],
                'api_key' => config('scout.typesense.client-settings.api_key', 'xyz'),
                'connection_timeout_seconds' => config('scout.typesense.client-settings.connection_timeout_seconds', 2),
            ]);
        });
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        if (! class_exists(\Laravel\Scout\EngineManager::class)) {
            return;
        }

        resolve(\Laravel\Scout\EngineManager::class)->extend('typesense', function () {
            return new TypesenseEngine($this->app->make(Client::class));
        });
    }
}
