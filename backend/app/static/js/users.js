async function api(url, method = "POST") {

    const r = await fetch(url, {
        method: method
    });

    const j = await r.json();

    alert(j.detail);

    if (r.ok)
        location.reload();

}

document.addEventListener("click", function (e) {

    if (e.target.closest(".menu-btn")) {

        const menu = e.target.closest(".actions-menu");
        const drop = menu.querySelector(".dropdown");

        document.querySelectorAll(".dropdown").forEach(d => {
            if (d !== drop)
                d.classList.remove("show");
        });

        drop.classList.toggle("show");

        e.stopPropagation();

        return;
    }

    document.querySelectorAll(".dropdown").forEach(d => d.classList.remove("show"));

});


document.querySelectorAll(".delete-user").forEach(btn => {

    btn.onclick = () => {

        if (!confirm("Delete user?"))
            return;

        api("/users/" + btn.dataset.user, "DELETE");

    };

});


document.querySelectorAll(".enable-user").forEach(btn => {

    btn.onclick = () => {

        api("/users/" + btn.dataset.user + "/enable");

    };

});


document.querySelectorAll(".disable-user").forEach(btn => {

    btn.onclick = () => {

        api("/users/" + btn.dataset.user + "/disable");

    };

});


document.querySelectorAll(".block-user").forEach(btn => {

    btn.onclick = () => {

        api("/users/" + btn.dataset.user + "/block");

    };

});


document.querySelectorAll(".unblock-user").forEach(btn => {

    btn.onclick = () => {

        api("/users/" + btn.dataset.user + "/unblock");

    };

});
