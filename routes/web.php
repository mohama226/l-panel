<?php


use Illuminate\Support\Facades\Route;


use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\LogoutController;


use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\VpnUserController;
use App\Http\Controllers\Admin\ServerController;
use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\ResellerController;





/*
|--------------------------------------------------------------------------
| Home
|--------------------------------------------------------------------------
*/


Route::get('/', function () {


    return redirect()
    ->route('admin.login');


});







/*
|--------------------------------------------------------------------------
| Admin Authentication
|--------------------------------------------------------------------------
*/


Route::prefix('admin')
->group(function(){



    Route::get(
        '/login',
        [
            LoginController::class,
            'showLogin'
        ]
    )
    ->name('admin.login');





    Route::post(
        '/login',
        [
            LoginController::class,
            'login'
        ]
    )
    ->name('admin.login.submit');





    Route::post(
        '/logout',
        [
            LogoutController::class,
            'logout'
        ]
    )
    ->name('admin.logout');



});









/*
|--------------------------------------------------------------------------
| Admin Panel
|--------------------------------------------------------------------------
*/


Route::prefix('admin')
->middleware('admin.auth')
->group(function(){





    /*
    Dashboard
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
    VPN Users
    */


    Route::resource(
        '/vpn-users',
        VpnUserController::class
    )
    ->names('vpn-users');





    Route::post(
        '/vpn-users/{vpnUser}/enable',
        [
            VpnUserController::class,
            'enable'
        ]
    )
    ->name('vpn-users.enable');





    Route::post(
        '/vpn-users/{vpnUser}/disable',
        [
            VpnUserController::class,
            'disable'
        ]
    )
    ->name('vpn-users.disable');









    /*
    OCServ Servers
    */


    Route::resource(
        '/servers',
        ServerController::class
    )
    ->names('servers');





    Route::post(
        '/servers/{server}/test',
        [
            ServerController::class,
            'test'
        ]
    )
    ->name('servers.test');





    Route::post(
        '/servers/{server}/restart',
        [
            ServerController::class,
            'restart'
        ]
    )
    ->name('servers.restart');









    /*
    Admin Management
    */


    Route::get(
        '/admins',
        [
            AdminController::class,
            'index'
        ]
    )
    ->name('admins.index');





    Route::post(
        '/admins',
        [
            AdminController::class,
            'store'
        ]
    )
    ->name('admins.store');









    /*
    Resellers
    */


    Route::resource(
        '/resellers',
        ResellerController::class
    )
    ->names('resellers');





});
