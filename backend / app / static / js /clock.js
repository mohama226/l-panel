// clock.js
// نمایش تاریخ و ساعت محلی به‌صورت زنده در عنصر با id="datetime"

(function () {
    function pad(n) {
        return n < 10 ? '0' + n : n;
    }

    function formatDateTime(date) {
        // گزینه: از toLocaleString برای نمایش بومی استفاده می‌کنیم.
        // اگر می‌خواهید فرمت خاصی (مثلاً فارسی) تحویل دهید، اینجا را تغییر دهید.
        const opts = {
            weekday: 'short',
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        };
        return date.toLocaleString(undefined, opts);
    }

    function updateClock() {
        const el = document.getElementById('datetime');
        if (!el) return;
        const now = new Date();
        el.textContent = formatDateTime(now);
    }

    // اولین بار بلافاصله به‌روزرسانی کن، سپس هر ثانیه
    document.addEventListener('DOMContentLoaded', function () {
        updateClock();
        setInterval(updateClock, 1000);
    });
})();
