#!/usr/bin/env bash


source "$(dirname "$0")/variables.sh"


if [ ! -f "$CONFIG_DIR/install.conf" ]

then

exit 0

fi


USERNAME=$(grep SUPERADMIN_USER $CONFIG_DIR/install.conf | cut -d= -f2)

PASSWORD=$(grep SUPERADMIN_PASS $CONFIG_DIR/install.conf | cut -d= -f2)



cd /opt/l-panel/backend


source venv/bin/activate


python3 <<EOF


from app.database import SessionLocal

from app.models import Admin

from app.security import hash_password



db=SessionLocal()


exist=db.query(Admin).filter(
Admin.username=="$USERNAME"
).first()


if not exist:

    admin=Admin(

    username="$USERNAME",

    password=hash_password("$PASSWORD"),

    role="superadmin"

    )


    db.add(admin)

    db.commit()


db.close()


EOF
