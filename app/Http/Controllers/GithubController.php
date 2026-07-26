<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Process;

class GithubController extends Controller
{

    public function index()
    {
        return view('admin.github');
    }


    public function push(Request $request)
    {

        $message = $request->message ?? "Update L-PANEL";


        $commands = [

            "cd /opt/l-panel",

            "git add .",

            "git commit -m \"$message\"",

            "git push origin main"

        ];


        $output = "";


        foreach($commands as $cmd)
        {

            $result = Process::run($cmd);

            $output .= "\n\nCOMMAND:\n".$cmd;

            $output .= "\n".$result->output();

            $output .= "\n".$result->errorOutput();

        }


        return back()->with(
            'result',
            $output
        );


    }


}
