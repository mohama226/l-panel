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


سلام

<?= $_SESSION['admin']; ?>

</div>



<div class="card">


<h3>

آمار پنل

</h3>


<div class="stat">

0

</div>


<p>

کاربر VPN

</p>


</div>



<?php

include "../includes/footer.php";

?>
