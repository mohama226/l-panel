-- جدول ادمین‌ها
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role ENUM('superadmin','admin','reseller') DEFAULT 'admin',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول کاربران پنل
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    reseller_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول نمایندگان (Resellers)
CREATE TABLE IF NOT EXISTS resellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    max_users INT DEFAULT 50,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول سرورهای Ocserv (Multi-Server)
CREATE TABLE IF NOT EXISTS ocserv_servers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ip VARCHAR(100),
    ssh_user VARCHAR(100),
    ssh_pass VARCHAR(255),
    ssh_port INT DEFAULT 22,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول وضعیت سرورها
CREATE TABLE IF NOT EXISTS ocserv_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    server_id INT,
    cpu_load VARCHAR(50),
    ram_usage VARCHAR(50),
    disk_usage VARCHAR(50),
    connections INT,
    ocserv_port INT,
    ocserv_version VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (server_id) REFERENCES ocserv_servers(id) ON DELETE CASCADE
);

-- جدول لاگ‌ها
CREATE TABLE IF NOT EXISTS logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول نسخه پنل
CREATE TABLE IF NOT EXISTS panel_info (
    id INT AUTO_INCREMENT PRIMARY KEY,
    version VARCHAR(20),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- مقدار اولیه نسخه پنل
INSERT INTO panel_info (version) VALUES ('1.0.0');
