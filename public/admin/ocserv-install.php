<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>Install Ocserv 1.5.0</title>
    <link rel="stylesheet" href="../assets/css/panel.css">
</head>
<body>

<div class="box">
    <h2>نصب Ocserv 1.5.0</h2>

    <form method="POST" action="actions/install-ocserv.php">
        <div class="input-group">
            <label>Port</label>
            <input type="number" name="port" placeholder="443" required>
        </div>

        <button class="btn">Install Ocserv</button>
    </form>

    <hr>

    <form method="POST" action="actions/remove-ocserv.php">
        <button class="btn-danger">Remove Ocserv</button>
    </form>
</div>

</body>
</html>
