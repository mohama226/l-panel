// clock.js
// نمایش تاریخ و ساعت محلی به‌صورت زنده در عنصر با id="datetime"

(function () {
    function formatDateTime(date) {
        // از toLocaleString استفاده می‌کنیم تا نمایش بومی باشد.
        // اگر بخواهی می‌توانیم locale را به 'fa-IR' یا چیز دیگر ثابت کنیم.
        const opts = {
            weekday: 'short',
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        };
        try {
            return date.toLocaleString(undefined, opts);
        } catch (e) {
            // fallback ساده
            const hh = String(date.getHours()).padStart(2, '0');
            const mm = String(date.getMinutes()).padStart(2, '0');
            const ss = String(date.getSeconds()).padStart(2, '0');
            return `${hh}:${mm}:${ss}`;
        }
    }

    function updateClock() {
        const el = document.getElementById('datetime');
        if (!el) return;
        const now = new Date();
        el.textContent = formatDateTime(now);
    }

    document.addEventListener('DOMContentLoaded', function () {
        updateClock();
        setInterval(updateClock, 1000);
    });
})();
