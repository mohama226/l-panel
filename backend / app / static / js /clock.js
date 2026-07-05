// backend/app/static/js/clock.js
// نمایش تاریخ و ساعت محلی به‌صورت زنده در عنصر با id="datetime"

(function () {
    function pad(n) {
        return n < 10 ? '0' + n : n;
    }

    function formatDateTime(date) {
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

    function initClock() {
        updateClock();
        // به‌روزرسانی هر 1 ثانیه
        setInterval(updateClock, 1000);
    }

    // اگر صفحه هنوز در حالت loading است، به DOMContentLoaded گوش بده
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initClock);
    } else {
        // صفحه قبلاً لود شده — بلافاصله اجرا کن
        initClock();
    }
})();
