<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/volt-test', function () {
    return view('volt.counter');
});
