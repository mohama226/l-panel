document.addEventListener("DOMContentLoaded",()=>{

    const toolbar=document.getElementById("bulk-toolbar");

    const counter=document.getElementById("selected-count");

    const selectAll=document.getElementById("select-all-users");

    function refresh(){

        const checked=document.querySelectorAll(".user-check:checked");

        counter.textContent=checked.length;

        toolbar.style.display=
            checked.length>0
            ? "flex"
            : "none";

    }

    if(selectAll){

        selectAll.addEventListener("change",()=>{

            document.querySelectorAll(".user-check")
            .forEach(c=>{

                c.checked=selectAll.checked;

            });

            refresh();

        });

    }

    document.querySelectorAll(".user-check")
    .forEach(c=>{

        c.addEventListener("change",refresh);

    });

});
