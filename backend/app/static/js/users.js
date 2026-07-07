document.addEventListener("click",function(e){

document.querySelectorAll(".dropdown").forEach(x=>{
if(!x.contains(e.target))
x.classList.remove("show");
});

if(e.target.closest(".menu-btn")){
let m=e.target.closest(".actions-menu");
m.querySelector(".dropdown").classList.toggle("show");
e.stopPropagation();
}

});
