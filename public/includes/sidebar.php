<?php

require_once "../../app/auth.php";

?>


<div class="sidebar">


<h2>
L-PANEL
</h2>


<div class="panel-clock">

    <div id="live-time">
        --:--:--
    </div>

    <div id="gregorian-date">
        ---
    </div>

    <div id="shamsi-date">
        ---
    </div>

</div>

  
<a href="/modiran/dashboard.php">
🏠 داشبورد
</a>



<a href="/modiran/users/">
👥 کاربران VPN
</a>



<?php if(isSuperAdmin()): ?>


<hr>


<h4>
مدیریت سیستم
</h4>



<a href="/modiran/admins.php">
👑 مدیران
</a>



<a href="/modiran/logs.php">
📋 لاگ مدیران
</a>


<?php endif; ?>



<a href="/logout.php">
🚪 خروج
</a>


</div>
