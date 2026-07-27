<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;


return new class extends Migration
{


public function up(): void
{


Schema::create('subscriptions',function(Blueprint $table){


$table->id();



$table->foreignId('vpn_user_id')
      ->constrained()
      ->cascadeOnDelete();



$table->date('start_date');


$table->date('end_date');



$table->bigInteger('traffic_limit')
      ->default(0);



$table->string('plan_name')
      ->nullable();



$table->boolean('active')
      ->default(true);



$table->timestamps();


});


}



public function down(): void
{
Schema::dropIfExists('subscriptions');
}


};
