<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;


return new class extends Migration
{


public function up(): void
{


Schema::create('subscriptions', function(Blueprint $table){


$table->id();



$table->foreignId('vpn_user_id')
->constrained(
'vpn_users'
)
->cascadeOnDelete();



$table->date('start_date');



$table->date('end_date');



$table->integer('days');



$table->decimal(
'price',
10,
2
)
->default(0);



$table->timestamps();



});



}



public function down(): void
{


Schema::dropIfExists('subscriptions');


}


};
