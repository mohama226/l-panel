function updateClock() {

    const el = document.getElementById("datetime");

    if (!el) return;

    const now = new Date();

    const date = now.toLocaleDateString("fa-IR", {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric"
    });

    const time = now.toLocaleTimeString("fa-IR", {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false
    });

    el.innerHTML = date + " | " + time;
}

updateClock();

setInterval(updateClock,1000);
