CREATE TABLE admins (
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



CREATE TABLE users (

id INT AUTO_INCREMENT PRIMARY KEY,

username VARCHAR(100) UNIQUE NOT NULL,

password VARCHAR(255) NOT NULL,

status ENUM('active','blocked') DEFAULT 'active',

expire_date DATE NULL,

total_gb INT DEFAULT 0,

used_gb INT DEFAULT 0,

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE admin_logs (

id INT AUTO_INCREMENT PRIMARY KEY,

admin VARCHAR(100),

action VARCHAR(255),

target_user VARCHAR(100),

ip VARCHAR(50),

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);
