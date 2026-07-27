<?php

namespace Database\Seeders;


use Illuminate\Database\Seeder;
use App\Models\Admin;
use Illuminate\Support\Facades\Hash;



class DatabaseSeeder extends Seeder
{


public function run(): void
{


Admin::create([

'name'=>'Super Admin',

'username'=>'admin',

'email'=>'admin@l-panel.local',

'password'=>Hash::make('admin123'),

'role'=>'superadmin'


]);


}


}
