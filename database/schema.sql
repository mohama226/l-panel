CREATE TABLE IF NOT EXISTS admins (

    id INT AUTO_INCREMENT PRIMARY KEY,

    username VARCHAR(50) UNIQUE NOT NULL,

    password VARCHAR(255) NOT NULL,

    role ENUM(
        'superadmin',
        'admin'
    ) DEFAULT 'admin',

    status ENUM(
        'active',
        'disabled'
    ) DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS admin_permissions (

    id INT AUTO_INCREMENT PRIMARY KEY,

    admin_id INT NOT NULL,

    permission VARCHAR(100) NOT NULL,

    FOREIGN KEY(admin_id)
    REFERENCES admins(id)
    ON DELETE CASCADE

);



CREATE TABLE IF NOT EXISTS admin_logs (

    id INT AUTO_INCREMENT PRIMARY KEY,

    admin VARCHAR(100),

    action VARCHAR(255),

    ip VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS users (

    id INT AUTO_INCREMENT PRIMARY KEY,

    username VARCHAR(100) UNIQUE,

    password VARCHAR(255),

    expire_date DATE,

    status ENUM(
        'active',
        'blocked'
    ) DEFAULT 'active',

    created_by INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);
