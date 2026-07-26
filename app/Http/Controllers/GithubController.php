<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class GithubController extends Controller
{

    public function index()
    {
        return view('settings.github');
    }


    public function push()
    {

        $output = [];

        exec("cd /opt/l-panel && git add . && git commit -m 'Update from L-PANEL' && git push origin main 2>&1", $output);


        return back()->with(
            'status',
            implode("\n",$output)
        );

    }

}
