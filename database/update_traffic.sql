CREATE TABLE IF NOT EXISTS user_traffic (

    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    upload_mb BIGINT DEFAULT 0,

    download_mb BIGINT DEFAULT 0,

    total_mb BIGINT DEFAULT 0,

    last_online DATETIME DEFAULT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE

);
