<?php


use Illuminate\Support\Facades\Route;



use App\Http\Controllers\Admin\VpnUserController;



/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/



Route::prefix('v1')
->group(function(){



/*
|--------------------------------------------------------------------------
| Health Check
|--------------------------------------------------------------------------
*/


Route::get(
    '/status',
    function(){

        return response()->json([

            'name'=>'L-PANEL',

            'status'=>'running',

            'version'=>'1.0.0'

        ]);

    }
);





});
