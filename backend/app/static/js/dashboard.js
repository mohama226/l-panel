async function refreshDashboard() {

    const box = document.getElementById("dashboard-content");

    if (!box) return;

    try {

        const res = await fetch("/dashboard/content", {
            cache: "no-store"
        });

        if (!res.ok) return;

        box.innerHTML = await res.text();

    } catch (e) {}

}

refreshDashboard();

setInterval(refreshDashboard, 2000);
