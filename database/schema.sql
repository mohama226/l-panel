/* ============================= */
/* 🔥 ساخت جدول admins (نسخه جدید) */
/* ============================= */

CREATE TABLE admins(

    id INT AUTO_INCREMENT PRIMARY KEY,

    username VARCHAR(50) NOT NULL UNIQUE,

    password VARCHAR(255) NOT NULL,

    firstname VARCHAR(100) DEFAULT NULL,

    lastname VARCHAR(100) DEFAULT NULL,

    description TEXT DEFAULT NULL,

    role ENUM('superadmin','admin')
    DEFAULT 'admin',

    status ENUM('active','disabled')
    DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



/* ============================= */
/* 🔥 جدول permissions */
/* ============================= */

CREATE TABLE permissions(

    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(100) UNIQUE NOT NULL,

    title VARCHAR(150) NOT NULL

);



/* مقداردهی اولیه permissions */

INSERT INTO permissions
(name,title)
VALUES
('user_create','ایجاد یوزر'),
('user_edit','ویرایش یوزر'),
('user_delete','حذف یوزر'),
('user_lock','لاک کردن یوزر'),
('service_manage','مدیریت سرویس ها'),
('admin_logs','مشاهده لاگ مدیران'),
('admin_manage','مدیریت مدیران');



/* ============================= */
/* 🔥 جدول admin_permissions */
/* ============================= */

CREATE TABLE admin_permissions(

    id INT AUTO_INCREMENT PRIMARY KEY,

    admin_id INT NOT NULL,

    permission VARCHAR(100) NOT NULL,

    FOREIGN KEY(admin_id)
    REFERENCES admins(id)
    ON DELETE CASCADE

);



/* ============================= */
/* 🔥 جدول admin_logs */
/* ============================= */

CREATE TABLE admin_logs (

    id INT AUTO_INCREMENT PRIMARY KEY,

    admin VARCHAR(100),

    action VARCHAR(255),

    ip VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



/* ============================= */
/* 🔥 جدول users */
/* ============================= */

CREATE TABLE users (

    id INT AUTO_INCREMENT PRIMARY KEY,

    username VARCHAR(100) UNIQUE,

    password VARCHAR(255),

    expire_date DATE,

    status ENUM('active','blocked')
    DEFAULT 'active',

    created_by INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



/* ============================= */
/* 🔥 حذف جدول‌ها (نسخه جدید) */
/* ============================= */

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS admin_permissions;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS admin_logs;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS=1;



/* ============================= */
/* 🔥 ساخت ادمین اولیه (نسخه جدید) */
/* ============================= */

INSERT INTO admins
(
    username,
    password,
    firstname,
    lastname,
    description,
    role
)
VALUES
(
    'admin',
    'PASSWORD_HASH',
    'مدیر',
    'اصلی',
    'Super Administrator',
    'superadmin'
);
