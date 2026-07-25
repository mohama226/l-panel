CREATE TABLE IF NOT EXISTS permissions (

    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE,

    title VARCHAR(150) NOT NULL

);



INSERT INTO permissions
(name,title)
VALUES

('user_edit','ویرایش یوزر'),

('user_create','ایجاد یوزر'),

('user_delete','حذف یوزر'),

('user_lock','لاک کردن یوزر'),

('user_unlock','باز کردن لاک یوزر'),

('user_view','مشاهده یوزر'),

('traffic_view','مشاهده مصرف'),

('backup_manage','مدیریت بکاپ'),

('service_manage','مدیریت سرویس ها');
