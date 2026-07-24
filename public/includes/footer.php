<?php

require_once __DIR__ . "/../../app/auth.php";

?>

</div>

</div>

<script>

function updateClock(){

    let now = new Date();

    let time = now.toLocaleTimeString('fa-IR');

    let gregorian = now.toLocaleDateString('en-US');

    document.getElementById("live-time").innerHTML = time;

    document.getElementById("gregorian-date").innerHTML =
        "میلادی : " + gregorian;

    let shamsi =
        new Intl.DateTimeFormat(
            'fa-IR-u-ca-persian',
            {
                year:'numeric',
                month:'long',
                day:'numeric'
            }
        ).format(now);

    document.getElementById("shamsi-date").innerHTML =
        "شمسی : " + shamsi;

}

setInterval(updateClock, 1000);

updateClock();

</script>

</body>

</html>
