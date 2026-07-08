let actionMenu = null;
let currentUser = null;

document.addEventListener("DOMContentLoaded", () => {

    actionMenu = document.getElementById("action-menu");

    document.addEventListener("click", (e) => {

        if (
            actionMenu &&
            !actionMenu.contains(e.target) &&
            !e.target.closest(".action-menu-button")
        ) {
            actionMenu.classList.remove("open");
            actionMenu.dataset.user = "";
        }

    });

    bindActions();

});

function openUserMenu(button, username){

    // اگر منوی همین کاربر باز است، ببند
    if(
        actionMenu.classList.contains("open") &&
        actionMenu.dataset.user === username
    ){
        actionMenu.classList.remove("open");
        actionMenu.dataset.user = "";
        return;
    }

    currentUser = username;
    actionMenu.dataset.user = username;

    document.getElementById("am-profile").href =
        "/users/" + username;

    document.getElementById("am-edit").href =
        "/users/" + username + "/edit";

    document.getElementById("am-logs").href =
        "/users/" + username;

    document.getElementById("am-traffic").href =
        "/users/" + username + "/traffic";

    actionMenu.classList.add("open");

    requestAnimationFrame(() => {

        const rect = button.getBoundingClientRect();

        const menuWidth = actionMenu.offsetWidth;
        const menuHeight = actionMenu.offsetHeight;

        let left = rect.right - menuWidth;
        let top = rect.bottom + 8;

        if (left + menuWidth > window.innerWidth - 10)
            left = window.innerWidth - menuWidth - 10;

        if (left < 10)
            left = 10;

        if (top + menuHeight > window.innerHeight - 10)
            top = rect.top - menuHeight - 8;

        if (top < 10)
            top = 10;

        actionMenu.style.left = left + "px";
        actionMenu.style.top = top + "px";

    });

}

function post(url){

    fetch(url,{
        method:"POST"
    })
    .then(r=>r.json())
    .then(j=>{
        alert(j.detail || "Done");
        location.reload();
    });

}

function bindActions(){

    document.getElementById("am-password").onclick=function(e){

        e.preventDefault();

        let p=prompt("New password");

        if(!p) return;

        fetch("/users/"+currentUser+"/password",{

            method:"POST",

            headers:{
                "Content-Type":"application/json"
            },

            body:JSON.stringify({
                password:p
            })

        })
        .then(r=>r.json())
        .then(j=>{
            alert(j.detail);
        });

    };

    document.getElementById("am-enable").onclick=function(e){

        e.preventDefault();
        post("/users/"+currentUser+"/enable");

    };

    document.getElementById("am-block").onclick=function(e){

        e.preventDefault();
        post("/users/"+currentUser+"/block");

    };

    document.getElementById("am-disconnect").onclick=function(e){

        e.preventDefault();
        post("/users/"+currentUser+"/disconnect");

    };

    document.getElementById("am-reset").onclick=function(e){

        e.preventDefault();

        if(confirm("Reset traffic?"))
            post("/users/"+currentUser+"/traffic/reset");

    };

    document.getElementById("am-delete").onclick=function(e){

        e.preventDefault();

        if(!confirm("Delete user?"))
            return;

        fetch("/users/"+currentUser,{
            method:"DELETE"
        })
        .then(r=>r.json())
        .then(j=>{
            alert(j.detail);
            location.reload();
        });

    };

}
