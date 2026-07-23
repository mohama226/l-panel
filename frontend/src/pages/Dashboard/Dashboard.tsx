import "./Dashboard.css";


function Dashboard(){

    return (

        <div className="dashboard">


            <header className="dashboard-header">


                <div>

                    <h1>
                        L-PANEL Dashboard
                    </h1>

                    <p>
                        Enterprise VPN Management Console
                    </p>

                </div>


                <button
                    className="logout"
                    onClick={()=>{
                        window.location.href="/login";
                    }}
                >

                    Logout

                </button>


            </header>



            <section className="cards">


                <div className="card">

                    <h3>
                        Ocserv Status
                    </h3>

                    <strong className="online">
                        Running
                    </strong>

                </div>



                <div className="card">

                    <h3>
                        Users
                    </h3>

                    <strong>
                        0
                    </strong>

                </div>



                <div className="card">

                    <h3>
                        Server CPU
                    </h3>

                    <strong>
                        5%
                    </strong>

                </div>



                <div className="card">

                    <h3>
                        Memory
                    </h3>

                    <strong>
                        13%
                    </strong>

                </div>


            </section>



            <section className="panel-box">


                <h2>
                    Server Information
                </h2>


                <div className="info-grid">


                    <span>
                        Version
                    </span>

                    <b>
                        L-PANEL 1.0
                    </b>



                    <span>
                        VPN Port
                    </span>

                    <b>
                        9735
                    </b>



                    <span>
                        Service
                    </span>

                    <b>
                        ocserv
                    </b>


                </div>


            </section>


        </div>

    );

}


export default Dashboard;
