<?php


namespace App\Http\Controllers\Auth;


use App\Http\Controllers\Controller;


use Illuminate\Http\Request;


use App\Models\Admin;


use Illuminate\Support\Facades\Hash;



class LoginController extends Controller
{



    public function showLogin()
    {


        return view(
            'admin.login'
        );


    }







    public function login(
        Request $request
    )
    {



        $data =
        $request->validate([


            'username'=>
            'required',


            'password'=>
            'required'


        ]);






        $admin =
        Admin::where(
            'username',
            $data['username']
        )
        ->first();







        if(
            !$admin ||
            !Hash::check(
                $data['password'],
                $admin->password
            )
        )
        {


            return back()
            ->withErrors([

                'username'=>
                'اطلاعات ورود صحیح نیست'

            ]);


        }








        if(
            !$admin->status
        )
        {


            return back()
            ->withErrors([

                'username'=>
                'حساب شما غیرفعال است'

            ]);


        }








        session([


            'admin_id'=>
            $admin->id,


            'admin_role'=>
            $admin->role



        ]);








        $admin->update([

            'last_login'=>
            now()

        ]);








        return redirect()
        ->route(
            'admin.dashboard'
        );



    }




}
