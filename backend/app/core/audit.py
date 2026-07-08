from fastapi import Request
from sqlalchemy.orm import Session

from app.db.models import AuditLog


def audit(
    db: Session,
    request: Request,
    admin,
    action: str,
    target: str = "",
    details: str = "",
    old_value: str = "",
    new_value: str = "",
    status: str = "SUCCESS",
):
    log = AuditLog(
        admin_username=getattr(admin, "username", "system"),
        target_user=target,
        action=action,
        details=details,
        old_value=old_value,
        new_value=new_value,
        ip_address=request.client.host if request.client else "",
        user_agent=request.headers.get("user-agent", ""),
        status=status,
    )

    db.add(log)
    db.commit()
