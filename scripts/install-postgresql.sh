#!/usr/bin/env bash

set -Eeuo pipefail

echo "=================================="
echo " Installing PostgreSQL"
echo "=================================="


if command -v psql >/dev/null 2>&1; then

    echo "PostgreSQL already installed:"
    psql --version

    exit 0

fi


if command -v dnf >/dev/null 2>&1; then

    dnf install -y postgresql-server postgresql-contrib

    postgresql-setup --initdb


elif command -v yum >/dev/null 2>&1; then

    yum install -y postgresql-server postgresql-contrib

    postgresql-setup --initdb


elif command -v apt >/dev/null 2>&1; then

    apt update

    apt install -y \
        postgresql \
        postgresql-contrib


else

    echo "Unsupported operating system."

    exit 1

fi


systemctl enable postgresql

systemctl start postgresql


echo
echo "Creating L-Panel database user"


DB_USER="lpanel"
DB_NAME="lpanel"


sudo -u postgres psql <<EOF

DO \$\$

BEGIN

IF NOT EXISTS (
    SELECT FROM pg_roles WHERE rolname='$DB_USER'
) THEN

CREATE USER $DB_USER WITH PASSWORD 'CHANGE_ME_PASSWORD';

END IF;

END

\$\$;


CREATE DATABASE $DB_NAME
OWNER $DB_USER;

EOF


echo
echo "=================================="
echo " PostgreSQL Ready"
echo "=================================="


echo "Database : $DB_NAME"
echo "User     : $DB_USER"
