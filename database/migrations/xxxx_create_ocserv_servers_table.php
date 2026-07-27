<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;


return new class extends Migration
{


public function up(): void
{


Schema::create('ocserv_servers', function(Blueprint $table){


$table->id();



$table->string('name');



$table->string('ip_address');



$table->integer('ssh_port')
->default(22);



$table->string('ssh_username')
->default('root');



$table->integer('ocserv_port')
->default(443);



$table->boolean('status')
->default(true);



$table->timestamps();



});



}



public function down(): void
{


Schema::dropIfExists('ocserv_servers');


}


};
