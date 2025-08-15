<?php

use function Livewire\Volt\{state};

state(['count' => 0]);

$increment = fn () => $this->count++;

?>

<div>
    <h1 class="text-2xl font-bold mb-4">Volt Counter</h1>
    <div class="text-center">
        <span class="text-4xl font-bold">{{ $count }}</span>
        <br>
        <button wire:click="increment" class="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
            Increment
        </button>
    </div>
</div>
