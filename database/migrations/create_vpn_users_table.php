<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;



return new class extends Migration
{


    public function up(): void
    {



        Schema::create('vpn_users', function(Blueprint $table){



            $table->id();



            $table->string('username')
                ->unique();



            $table->string('password');



            $table->foreignId('server_id')
                ->constrained(
                    'ocserv_servers'
                )
                ->cascadeOnDelete();




            $table->foreignId('reseller_id')
                ->nullable()
                ->constrained(
                    'resellers'
                )
                ->nullOnDelete();




            $table->foreignId('created_by')
                ->nullable()
                ->constrained(
                    'admins'
                )
                ->nullOnDelete();




            $table->date('expire_date')
                ->nullable();




            $table->boolean('status')
                ->default(true);



            $table->timestamps();



        });



    }





    public function down(): void
    {

        Schema::dropIfExists('vpn_users');

    }


};
