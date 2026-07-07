async function postAction(url, message){

    const r = await fetch(url,{
        method:"POST"
    });

    const j = await r.json();

    alert(j.detail || message);

    location.reload();

}

document.addEventListener("click",function(e){

    document.querySelectorAll(".dropdown").forEach(d=>{

        if(!d.parentElement.contains(e.target))
            d.classList.remove("show");

    });

    const btn=e.target.closest(".menu-btn");

    if(btn){

        e.stopPropagation();

        const menu=btn.parentElement.querySelector(".dropdown");

        document.querySelectorAll(".dropdown").forEach(d=>{

            if(d!==menu)
                d.classList.remove("show");

        });

        menu.classList.toggle("show");

    }

});


document.addEventListener("click",async function(e){

    const a=e.target.closest("a");

    if(!a) return;


    if(a.classList.contains("enable-user")){

        e.preventDefault();

        await postAction("/users/"+a.dataset.user+"/enable");

    }


    if(a.classList.contains("disable-user")){

        e.preventDefault();

        await postAction("/users/"+a.dataset.user+"/disable");

    }


    if(a.classList.contains("block-user")){

        e.preventDefault();

        await postAction("/users/"+a.dataset.user+"/block");

    }


    if(a.classList.contains("unblock-user")){

        e.preventDefault();

        await postAction("/users/"+a.dataset.user+"/unblock");

    }


    if(a.classList.contains("reset-traffic")){

        e.preventDefault();

        if(!confirm("Reset traffic?")) return;

        await postAction("/users/"+a.dataset.user+"/traffic/reset");

    }


    if(a.classList.contains("delete-user")){

        e.preventDefault();

        if(!confirm("Delete user?")) return;

        const r=await fetch("/users/"+a.dataset.user,{
            method:"DELETE"
        });

        const j=await r.json();

        alert(j.detail);

        location.reload();

    }

});
