CREATE TABLE IF NOT EXISTS admins (

id INT AUTO_INCREMENT PRIMARY KEY,

username VARCHAR(50) UNIQUE NOT NULL,

password VARCHAR(255) NOT NULL,

fullname VARCHAR(100),

role ENUM(
'superadmin',
'admin'
) DEFAULT 'admin',

status ENUM(
'active',
'blocked'
) DEFAULT 'active',

permissions TEXT,

last_login DATETIME NULL,

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS users (

id INT AUTO_INCREMENT PRIMARY KEY,

username VARCHAR(100) UNIQUE NOT NULL,

password VARCHAR(255) NOT NULL,

status ENUM('active','blocked') DEFAULT 'active',

expire_date DATE NULL,

total_gb INT DEFAULT 0,

used_gb INT DEFAULT 0,

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS admin_logs (

id INT AUTO_INCREMENT PRIMARY KEY,

admin_id INT,

action VARCHAR(100),

description TEXT,

ip VARCHAR(50),

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);
