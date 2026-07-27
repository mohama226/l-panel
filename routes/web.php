<?php

use Illuminate\Support\Facades\Route;


use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\VpnUserController;
use App\Http\Controllers\Admin\ServerController;
use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\ResellerController;



/*
|--------------------------------------------------------------------------
| Public Routes
|--------------------------------------------------------------------------
*/


Route::get('/', function () {

    return redirect('/admin/login');

});





/*
|--------------------------------------------------------------------------
| Admin Panel Routes
|--------------------------------------------------------------------------
*/


Route::prefix('admin')
->middleware(['auth:admin'])
->group(function(){



/*
|--------------------------------------------------------------------------
| Dashboard
|--------------------------------------------------------------------------
*/


Route::get(
    '/dashboard',
    [
        DashboardController::class,
        'index'
    ]
)
->name('admin.dashboard');





/*
|--------------------------------------------------------------------------
| VPN Users
|--------------------------------------------------------------------------
*/


Route::prefix('vpn-users')
->group(function(){


    Route::get(
        '/',
        [
            VpnUserController::class,
            'index'
        ]
    )
    ->name('vpn-users.index');



    Route::get(
        '/create',
        [
            VpnUserController::class,
            'create'
        ]
    )
    ->name('vpn-users.create');



    Route::post(
        '/',
        [
            VpnUserController::class,
            'store'
        ]
    )
    ->name('vpn-users.store');



    Route::delete(
        '/{vpnUser}',
        [
            VpnUserController::class,
            'destroy'
        ]
    )
    ->name('vpn-users.destroy');



    Route::post(
        '/{vpnUser}/enable',
        [
            VpnUserController::class,
            'enable'
        ]
    )
    ->name('vpn-users.enable');



    Route::post(
        '/{vpnUser}/disable',
        [
            VpnUserController::class,
            'disable'
        ]
    )
    ->name('vpn-users.disable');


});







/*
|--------------------------------------------------------------------------
| OCServ Servers
|--------------------------------------------------------------------------
*/


Route::prefix('servers')
->group(function(){



Route::get(
    '/',
    [
        ServerController::class,
        'index'
    ]
)
->name('servers.index');




Route::get(
    '/create',
    [
        ServerController::class,
        'create'
    ]
)
->name('servers.create');




Route::post(
    '/',
    [
        ServerController::class,
        'store'
    ]
)
->name('servers.store');





Route::post(
    '/{server}/test',
    [
        ServerController::class,
        'test'
    ]
)
->name('servers.test');





Route::delete(
    '/{server}',
    [
        ServerController::class,
        'destroy'
    ]
)
->name('servers.destroy');



});








/*
|--------------------------------------------------------------------------
| Admin Management
|--------------------------------------------------------------------------
*/


Route::prefix('admins')
->group(function(){



Route::get(
    '/',
    [
        AdminController::class,
        'index'
    ]
)
->name('admins.index');




Route::post(
    '/',
    [
        AdminController::class,
        'store'
    ]
)
->name('admins.store');




Route::delete(
    '/{admin}',
    [
        AdminController::class,
        'destroy'
    ]
)
->name('admins.destroy');



});








/*
|--------------------------------------------------------------------------
| Reseller Management
|--------------------------------------------------------------------------
*/


Route::prefix('resellers')
->group(function(){



Route::get(
    '/',
    [
        ResellerController::class,
        'index'
    ]
)
->name('resellers.index');




Route::get(
    '/create',
    [
        ResellerController::class,
        'create'
    ]
)
->name('resellers.create');




Route::post(
    '/',
    [
        ResellerController::class,
        'store'
    ]
)
->name('resellers.store');




Route::delete(
    '/{reseller}',
    [
        ResellerController::class,
        'destroy'
    ]
)
->name('resellers.destroy');



});



});
