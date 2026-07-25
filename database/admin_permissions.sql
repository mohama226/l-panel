CREATE TABLE IF NOT EXISTS permissions(

id int AUTO_INCREMENT PRIMARY KEY,

name varchar(100),

title varchar(150)

);


INSERT INTO permissions(name,title) VALUES

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

