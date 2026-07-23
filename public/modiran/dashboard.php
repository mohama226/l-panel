<?php

require "../../app/auth.php";

checkLogin();

include "../includes/header.php";

include "../includes/sidebar.php";

?>


<div class="topbar">

    <h2>
        داشبورد مدیریت
    </h2>


    <p>
        خوش آمدید
        <?= $_SESSION['admin']; ?>
    </p>


</div>



<div class="row">


<div class="card">

    <h3>
        کاربران VPN
    </h3>


    <div class="stat">
        0
    </div>


    <p>
        تعداد کاربران
    </p>


</div>



<br>



<div class="card">

    <h3>
        کاربران فعال
    </h3>


    <div class="stat">
        0
    </div>


    <p>
        اتصال فعال
    </p>


</div>



<br>



<div class="card">

    <h3>
        سرورها
    </h3>


    <div class="stat">
        1
    </div>


    <p>
        سرورهای متصل
    </p>


</div>



</div>



<br>


<a href="/logout.php">

    خروج از پنل

</a>



<?php

include "../includes/footer.php";

?>
