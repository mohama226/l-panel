document.addEventListener("DOMContentLoaded", () => {
    const box = document.querySelector(".login-box");
    box.style.transform = "scale(0.95)";
    setTimeout(() => {
        box.style.transition = "0.4s";
        box.style.transform = "scale(1)";
    }, 150);
});
