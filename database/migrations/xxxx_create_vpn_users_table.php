<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;


return new class extends Migration
{


public function up(): void
{


Schema::create('vpn_users',function(Blueprint $table){


$table->id();



$table->foreignId('server_id')
      ->constrained('ocserv_servers')
      ->cascadeOnDelete();



$table->foreignId('created_by')
      ->nullable()
      ->constrained('admins')
      ->nullOnDelete();



$table->foreignId('reseller_id')
      ->nullable()
      ->constrained('resellers')
      ->nullOnDelete();



$table->string('username')
      ->unique();



$table->string('password');



$table->date('expire_date')
      ->nullable();



$table->bigInteger('traffic_limit')
      ->default(0);



$table->bigInteger('traffic_used')
      ->default(0);



$table->integer('device_limit')
      ->default(1);



$table->boolean('status')
      ->default(true);



$table->timestamp('last_login')
      ->nullable();



$table->string('last_ip')
      ->nullable();



$table->timestamps();



$table->index([
'server_id',
'status'
]);


});


}



public function down(): void
{

Schema::dropIfExists('vpn_users');

}


};
