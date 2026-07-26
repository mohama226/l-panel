#!/bin/bash


create_env(){

ENV_FILE="/opt/l-panel/.env"


cat > $ENV_FILE <<EOF

APP_NAME=L-Panel
APP_ENV=production
APP_DEBUG=false

APP_URL=http://127.0.0.1

DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=$DB_NAME
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASS

TIMEZONE=UTC

EOF


ok ".env created"


}
