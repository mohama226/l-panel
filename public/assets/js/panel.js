document.addEventListener("DOMContentLoaded", () => {
    const btn = document.getElementById("toggle-theme");
    if (!btn) return;

    let dark = true;

    btn.addEventListener("click", () => {
        dark = !dark;
        if (!dark) {
            document.documentElement.style.setProperty('--bg-main', '#f3f4f6');
            document.documentElement.style.setProperty('--bg-sidebar', '#111827');
            document.documentElement.style.setProperty('--bg-card', '#ffffff');
            document.documentElement.style.setProperty('--text-main', '#111827');
            document.documentElement.style.setProperty('--text-muted', '#6b7280');
            document.documentElement.style.setProperty('--border-soft', '#e5e7eb');
        } else {
            document.documentElement.style.setProperty('--bg-main', '#0f172a');
            document.documentElement.style.setProperty('--bg-sidebar', '#020617');
            document.documentElement.style.setProperty('--bg-card', '#1e293b');
            document.documentElement.style.setProperty('--text-main', '#e5e7eb');
            document.documentElement.style.setProperty('--text-muted', '#9ca3af');
            document.documentElement.style.setProperty('--border-soft', '#1f2937');
        }
    });
});
