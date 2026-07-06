from sqlalchemy.orm import Session

from app.db.models import UserLog


class UserLogRepository:

    def __init__(self, db: Session):
        self.db = db

    def create(self, username, event, ip="", details=""):

        log = UserLog(
            username=username,
            event=event,
            ip=ip,
            details=details,
        )

        self.db.add(log)
        self.db.commit()

        return log

    def get_user_logs(self, username, limit=200):

        return (
            self.db.query(UserLog)
            .filter(UserLog.username == username)
            .order_by(UserLog.created_at.desc())
            .limit(limit)
            .all()
        )

    def delete_user_logs(self, username):

        (
            self.db.query(UserLog)
            .filter(UserLog.username == username)
            .delete()
        )

        self.db.commit()
