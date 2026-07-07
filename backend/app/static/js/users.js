document.addEventListener("DOMContentLoaded", () => {

    const menus = document.querySelectorAll(".actions-menu");

    menus.forEach(menu => {

        const button = menu.querySelector(".menu-btn");
        const dropdown = menu.querySelector(".dropdown");

        button.addEventListener("click", function (e) {

            e.preventDefault();
            e.stopPropagation();

            // بستن منوهای دیگر
            document.querySelectorAll(".dropdown.show").forEach(d => {
                if (d !== dropdown) {
                    d.classList.remove("show");
                }
            });

            // باز/بسته کردن همین منو
            dropdown.classList.toggle("show");

        });

    });

    // کلیک بیرون از منو => بستن
    document.addEventListener("click", function () {
        document.querySelectorAll(".dropdown.show").forEach(d => {
            d.classList.remove("show");
        });
    });

});
