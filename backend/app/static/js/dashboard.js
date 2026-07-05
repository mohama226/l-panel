let dashboardTimer = null;

function setText(id, value) {

    const el = document.getElementById(id);

    if (el)
        el.textContent = value;

}

function setBar(barId, textId, value) {

    const bar = document.getElementById(barId);

    const text = document.getElementById(textId);

    if (bar)
        bar.style.width = value + "%";

    if (text)
        text.textContent = value + "%";

}

async function updateDashboard() {

    try {

        const response = await fetch("/api/dashboard/stats", {
            cache: "no-store"
        });

        if (!response.ok)
            return;

        const data = await response.json();

        setText("users-value", data.users);
        setText("admins-value", data.admins);
        setText("servers-value", data.servers);
        setText("online-value", data.online);

        setBar("cpu-bar", "cpu-text", data.cpu);
        setBar("ram-bar", "ram-text", data.ram);
        setBar("disk-bar", "disk-text", data.disk);

        setText("load-value", data.load);
        setText("uptime-value", data.uptime);

        setText("upload-value", data.traffic_up + " MB");
        setText("download-value", data.traffic_down + " MB");

    }

    catch (e) {

        console.log("Dashboard refresh failed.", e);

    }

}

function startDashboardRefresh() {

    if (dashboardTimer)
        clearInterval(dashboardTimer);

    let interval = 2;

    if (
        window.dashboardSettings &&
        window.dashboardSettings.autoRefresh
    ) {

        interval = parseInt(
            window.dashboardSettings.interval
        );

    }

    updateDashboard();

    dashboardTimer = setInterval(

        updateDashboard,

        interval * 1000

    );

}

document.addEventListener(

    "DOMContentLoaded",

    startDashboardRefresh

);
