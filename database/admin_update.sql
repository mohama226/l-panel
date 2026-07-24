ALTER TABLE admins
ADD COLUMN email VARCHAR(100) NULL AFTER username,
ADD COLUMN status ENUM('active','disabled') DEFAULT 'active',
ADD COLUMN permissions TEXT NULL AFTER role;


UPDATE admins
SET role='superadmin'
WHERE role='admin';
