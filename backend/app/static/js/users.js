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
