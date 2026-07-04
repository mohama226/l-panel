async function refreshDashboard(){

    const response = await fetch("/api/dashboard");

    const data = await response.json();

    document.getElementById("cpu").innerText=data.cpu+" %";

    document.getElementById("ram").innerText=data.ram+" %";

    document.getElementById("disk").innerText=data.disk+" %";

    document.getElementById("uptime").innerText=data.uptime;

    document.getElementById("ocserv").innerText=data.ocserv;

}

setInterval(refreshDashboard,5000);
