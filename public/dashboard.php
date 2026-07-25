<?php
session_start();
require_once __DIR__ . '/../system/config.php';
require_once __DIR__ . '/../app/Core/Auth.php';

Auth::requireAdmin();

$page_title = 'داشبورد مدیریت';

ob_start();
?>
<div class="cards">
    <div class="card">
        <div class="card-title">کل کاربران VPN</div>
        <div class="card-value">123</div>
    </div>
    <div class="card">
        <div class="card-title">سرورهای فعال</div>
        <div class="card-value">4</div>
    </div>
    <div class="card">
        <div class="card-title">نماینده‌ها</div>
        <div class="card-value">7</div>
    </div>
</div>

<div class="panel-section">
    <div class="section-header">
        <h3>آخرین کاربران ساخته‌شده</h3>
    </div>
    <table class="table">
        <thead>
            <tr>
                <th>یوزرنیم</th>
                <th>سرور</th>
                <th>نماینده</th>
                <th>انقضا</th>
                <th>وضعیت</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>testuser1</td>
                <td>DE-1</td>
                <td>reseller1</td>
                <td>2026-08-01</td>
                <td><span class="badge badge-success">Active</span></td>
            </tr>
            <tr>
                <td>testuser2</td>
                <td>NL-2</td>
                <td>reseller2</td>
                <td>2026-07-30</td>
                <td><span class="badge badge-warning">Expiring</span></td>
            </tr>
        </tbody>
    </table>
</div>
<?php
$content = ob_get_clean();
require __DIR__ . '/layout.php';
