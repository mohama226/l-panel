function postAction(url, message){

    fetch(url,{
        method:"POST"
    })
    .then(r=>r.json())
    .then(j=>{
        alert(j.detail || message);
        location.reload();
    });

}

// ----------------------
// Menu
// ----------------------

document.addEventListener("click",function(e){

    if(e.target.closest(".menu-btn")){

        let menu=e.target.closest(".actions-menu");

        let drop=menu.querySelector(".dropdown");

        if(drop.classList.contains("show")){
            drop.classList.remove("show");
        }else{

            document.querySelectorAll(".dropdown").forEach(d=>{
                d.classList.remove("show");
            });

            drop.classList.add("show");
        }

        e.stopPropagation();
        return;
    }

    document.querySelectorAll(".dropdown").forEach(d=>{
        d.classList.remove("show");
    });

});

// ----------------------
// Delete
// ----------------------

document.querySelectorAll(".delete-user").forEach(btn=>{

    btn.onclick=()=>{

        if(!confirm("Delete user?")) return;

        fetch("/users/"+btn.dataset.user,{
            method:"DELETE"
        })
        .then(r=>r.json())
        .then(j=>{
            alert(j.detail);
            location.reload();
        });

    };

});

// ----------------------
// Enable
// ----------------------

document.querySelectorAll(".enable-user").forEach(btn=>{

    btn.onclick=()=>{

        postAction(
            "/users/"+btn.dataset.user+"/enable",
            "User Enabled"
        );

    };

});

// ----------------------
// Disable
// ----------------------

document.querySelectorAll(".disable-user").forEach(btn=>{

    btn.onclick=()=>{

        postAction(
            "/users/"+btn.dataset.user+"/disable",
            "User Disabled"
        );

    };

});

// ----------------------
// Block
// ----------------------

document.querySelectorAll(".block-user").forEach(btn=>{

    btn.onclick=()=>{

        postAction(
            "/users/"+btn.dataset.user+"/block",
            "User Blocked"
        );

    };

});

// ----------------------
// Unblock
// ----------------------

document.querySelectorAll(".unblock-user").forEach(btn=>{

    btn.onclick=()=>{

        postAction(
            "/users/"+btn.dataset.user+"/unblock",
            "User Unblocked"
        );

    };

});

// ----------------------
// Reset Traffic
// ----------------------

document.querySelectorAll(".reset-traffic").forEach(btn=>{

    btn.onclick=()=>{

        postAction(
            "/users/"+btn.dataset.user+"/traffic/reset",
            "Traffic Reset"
        );

    };

});

// ----------------------
// Disconnect
// ----------------------

document.querySelectorAll(".disconnect-user").forEach(btn=>{

    btn.onclick=()=>{

        postAction(
            "/users/"+btn.dataset.user+"/disconnect",
            "User Disconnected"
        );

    };

});
