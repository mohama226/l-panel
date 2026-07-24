CREATE TABLE IF NOT EXISTS admin_permissions (

id INT AUTO_INCREMENT PRIMARY KEY,

admin_id INT NOT NULL,

permission VARCHAR(100) NOT NULL,


FOREIGN KEY(admin_id)
REFERENCES admins(id)
ON DELETE CASCADE

);



INSERT INTO admin_permissions
(admin_id,permission)

SELECT id,'users_manage'
FROM admins
WHERE role='superadmin';
