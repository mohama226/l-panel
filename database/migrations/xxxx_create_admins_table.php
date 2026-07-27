<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;


return new class extends Migration
{


public function up(): void
{


Schema::create('admins', function (Blueprint $table) {


$table->id();


$table->string('name');


$table->string('username')
->unique();


$table->string('email')
->nullable()
->unique();



$table->string('password');



$table->enum(
'role',
[
'superadmin',
'admin',
'reseller'
]
)
->default('admin');



$table->boolean('status')
->default(true);



$table->timestamp('last_login')
->nullable();



$table->timestamps();



});



}



public function down(): void
{


Schema::dropIfExists('admins');


}


};
