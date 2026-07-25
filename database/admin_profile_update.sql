ALTER TABLE admins
ADD COLUMN firstname varchar(50) DEFAULT NULL,
ADD COLUMN lastname varchar(50) DEFAULT NULL,
ADD COLUMN description text DEFAULT NULL;
