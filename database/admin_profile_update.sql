ALTER TABLE admins
ADD COLUMN firstname VARCHAR(100) NULL AFTER username,
ADD COLUMN lastname VARCHAR(100) NULL AFTER firstname,
ADD COLUMN description TEXT NULL AFTER lastname;
