<?php


use Illuminate\Database\Migrations\Migration;

use Illuminate\Database\Schema\Blueprint;

use Illuminate\Support\Facades\Schema;



return new class extends Migration
{


public function up(): void
{

Schema::create('admins',function(Blueprint $table){

$table->id();

$table->string('username')->unique();

$table->string('password');

$table->string('email')->nullable();

$table->string('role')->default('superadmin');

$table->boolean('status')->default(1);

$table->timestamps();


});


}



public function down(): void
{

Schema::dropIfExists('admins');

}


};
