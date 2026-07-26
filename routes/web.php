<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;

Route::get('/', function () {
    return redirect('/login');
});

Route::get('/login', [
    AuthController::class,
    'show'
])->name('login');

Route::post('/login', [
    AuthController::class,
    'login'
]);

Route::middleware('auth:admin')->group(function () {

    Route::get('/dashboard', [
        DashboardController::class,
        'index'
    ]);

    Route::post('/logout', [
        AuthController::class,
        'logout'
    ]);

});

use App\Http\Controllers\GithubController;

Route::middleware('auth')->group(function () {

    Route::get(
        '/admin/github',
        [GithubController::class, 'index']
    );

    Route::post(
        '/admin/github/push',
        [GithubController::class, 'push']
    );

});
