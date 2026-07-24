<?php
?>

</div>

<footer class="footer">


</footer>


<script>


// حذف ساعت و تاریخ سایدبار
document.addEventListener("DOMContentLoaded", function(){

    let clock = document.getElementById("live-time");
    let gdate = document.getElementById("gregorian-date");
    let sdate = document.getElementById("shamsi-date");


    if(clock){
        clock.remove();
    }


    if(gdate){
        gdate.remove();
    }


    if(sdate){
        sdate.remove();
    }


});


</script>


</body>

</html>
