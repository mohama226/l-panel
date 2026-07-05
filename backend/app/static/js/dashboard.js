// ==============================
// LAK PANEL Dashboard Auto Refresh
// ==============================

let refreshTimer = null;

async function refreshDashboard() {

    try {

        const response = await fetch("/dashboard/content", {
            cache: "no-store"
        });

        if (!response.ok) {
            return;
        }

        const html = await response.text();

        const target = document.getElementById("dashboard-content");

        if (target) {

            target.innerHTML = html;

        }

    } catch (err) {

        console.error("Dashboard Refresh Error:", err);

    }

}

function startDashboardRefresh() {

    if (typeof window.dashboardSettings === "undefined") {

        return;

    }

    if (!window.dashboardSettings.autoRefresh) {

        return;

    }

    let interval = parseInt(window.dashboardSettings.interval);

    if (isNaN(interval) || interval < 1) {

        interval = 2;

    }

    if (refreshTimer) {

        clearInterval(refreshTimer);

    }

    refreshTimer = setInterval(

        refreshDashboard,

        interval * 1000

    );

}

document.addEventListener(

    "DOMContentLoaded",

    function () {

        startDashboardRefresh();

    }

);
