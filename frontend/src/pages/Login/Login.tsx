import { useState } from "react";

import "./Login.css";


function Login(){

    const [username,setUsername] = useState("");

    const [password,setPassword] = useState("");

    const [loading,setLoading] = useState(false);


    function handleLogin(e:React.FormEvent){

        e.preventDefault();

        setLoading(true);


        setTimeout(()=>{

            window.location.href="/dashboard";

        },700);

    }


    return (

        <div className="login-page">


            <div className="login-box">


                <div className="login-header">

                    <div className="logo">

                        L

                    </div>


                    <h1>

                        L-PANEL

                    </h1>


                    <p>

                        Enterprise VPN Management

                    </p>

                </div>



                <form onSubmit={handleLogin}>


                    <div className="field">

                        <label>

                            Username

                        </label>


                        <input

                            value={username}

                            onChange={
                                e=>setUsername(e.target.value)
                            }

                            placeholder="admin"

                        />

                    </div>



                    <div className="field">


                        <label>

                            Password

                        </label>


                        <input

                            type="password"

                            value={password}

                            onChange={
                                e=>setPassword(e.target.value)
                            }

                            placeholder="••••••••"

                        />


                    </div>



                    <button

                        disabled={loading}

                    >

                        {
                            loading
                            ?
                            "Loading..."
                            :
                            "Login"
                        }


                    </button>


                </form>


            </div>


        </div>

    );

}


export default Login;
