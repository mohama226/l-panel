<?php


use Illuminate\Support\Facades\Route;



use App\Http\Controllers\Admin\ServerController;





/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/





Route::get(
    '/status',
    function(){

        return response()->json([


            'name'=>'L-PANEL',

            'status'=>'running',

            'version'=>'1.0'


        ]);


    }
);







/*
|--------------------------------------------------------------------------
| Server API
|--------------------------------------------------------------------------
*/


Route::prefix('servers')
->group(function(){



    Route::get(
        '/{server}/status',
        [
            ServerController::class,
            'test'
        ]
    );


});
