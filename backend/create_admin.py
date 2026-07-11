import os

from app.db.database import SessionLocal, engine, Base
from app.db.models import Admin, Role
from app.core.security import hash_password


Base.metadata.create_all(bind=engine)


db = SessionLocal()


username = os.getenv("SUPERADMIN_USERNAME", "admin")
password = os.getenv("SUPERADMIN_PASSWORD", "admin123")


role = db.query(Role).filter(Role.name == "Super Admin").first()


if role is None:
    role = Role(
        name="Super Admin",
        description="Full Access"
    )

    db.add(role)
    db.commit()
    db.refresh(role)



admin = db.query(Admin).filter(
    Admin.username == username
).first()


if admin is None:

    admin = Admin(
        username=username,
        fullname="Super Administrator",
        password=hash_password(password),
        role_id=role.id,
        active=True
    )

    db.add(admin)
    db.commit()

    print("Superadmin Created")


else:

    print("Admin already exists")


db.close()
