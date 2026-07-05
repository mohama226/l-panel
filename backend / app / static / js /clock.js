// clock.js — نمایش ساعت و تاریخ شمسی زنده

(function () {

  function updateClock() {
    const timeEl = document.getElementById('clock-time');
    const dateEl = document.getElementById('clock-date');
    if (!timeEl || !dateEl) return;

    const now = new Date();

    // ساعت (HH:MM:SS)
    const hours   = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');
    timeEl.textContent = `${hours}:${minutes}:${seconds}`;

    // تاریخ شمسی با Intl API
    try {
      const jalali = new Intl.DateTimeFormat('fa-IR', {
        calendar: 'persian',
        weekday: 'long',
        year:    'numeric',
        month:   'long',
        day:     'numeric',
      }).format(now);
      dateEl.textContent = jalali;
    } catch (e) {
      // fallback اگر مرورگر پشتیبانی نکرد
      dateEl.textContent = now.toLocaleDateString('fa-IR');
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    updateClock();
    setInterval(updateClock, 1000);
  });

})();
