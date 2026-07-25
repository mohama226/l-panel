CREATE TABLE IF NOT EXISTS permissions (

id INT AUTO_INCREMENT PRIMARY KEY,

name VARCHAR(100) NOT NULL,

title VARCHAR(150) NOT NULL

);



INSERT INTO permissions
(name,title)
VALUES

('users_view','مشاهده کاربران'),

('users_create','ایجاد کاربر'),

('users_edit','ویرایش کاربر'),

('users_delete','حذف کاربر'),

('users_lock','لاک کردن کاربر'),

('users_unlock','باز کردن کاربر'),

('services_manage','مدیریت سرویس ها'),

('logs_view','مشاهده لاگ ها'),

('backup_manage','مدیریت بکاپ'),

('settings_manage','تنظیمات پنل');
