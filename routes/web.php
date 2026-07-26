<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;



Route::get('/login',[AuthController::class,'login'])
->name('login');


Route::post('/login',[AuthController::class,'authenticate']);


Route::get('/dashboard',[DashboardController::class,'index'])
->middleware('auth');



Route::post('/logout',[AuthController::class,'logout']);



Route::get('/',function(){

    return redirect('/login');

});
