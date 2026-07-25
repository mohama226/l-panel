CREATE TABLE IF NOT EXISTS permissions(

id INT AUTO_INCREMENT PRIMARY KEY,

name VARCHAR(100) UNIQUE,

title VARCHAR(150)

);



INSERT IGNORE INTO permissions
(name,title)

VALUES

('user_create','ایجاد یوزر'),

('user_edit','ویرایش یوزر'),

('user_delete','حذف یوزر'),

('user_lock','لاک کردن یوزر'),

('service_manage','مدیریت سرویس‌ها'),

('admin_logs','مشاهده لاگ مدیران'),

('admin_manage','مدیریت مدیران');
