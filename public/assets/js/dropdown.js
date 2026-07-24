document.addEventListener("DOMContentLoaded", function(){

    document.querySelectorAll(".action-btn").forEach(btn=>{

        btn.addEventListener("click",function(e){

            e.stopPropagation();

            let menu=this.nextElementSibling;

            document.querySelectorAll(".action-menu")
            .forEach(m=>{
                if(m!==menu)
                    m.classList.remove("show");
            });


            let rect=this.getBoundingClientRect();

            menu.classList.add("show");


            let menuHeight=menu.offsetHeight;
            let menuWidth=menu.offsetWidth;


            let top=rect.bottom + 5;
            let left=rect.left;


            // اگر پایین جا نبود
            if(top + menuHeight > window.innerHeight){

                top = rect.top - menuHeight - 5;

            }


            // اگر سمت راست جا نبود
            if(left + menuWidth > window.innerWidth){

                left = window.innerWidth - menuWidth - 10;

            }


            menu.style.top = top+"px";
            menu.style.left = left+"px";


        });

    });



    document.addEventListener("click",function(){

        document.querySelectorAll(".action-menu")
        .forEach(m=>{
            m.classList.remove("show");
        });

    });


});
