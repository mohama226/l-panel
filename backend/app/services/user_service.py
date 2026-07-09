from app.core.audit import audit
from app.db.models import VPNUser, AuditLog
from app.services.ocserv_service import OcservService
from app.services.audit import log_action


class UserService:
    def __init__(self, repo, log_repo):
        self.repo = repo
        self.log_repo = log_repo

    # =====================================================
    # Basic
    # =====================================================
    def list(self):
        return self.repo.get_all()

    def get(self, username):
        return self.repo.get(username)

    def logs(self, username):
        return self.log_repo.list(username)

    def audit_logs(self, username):
        return (
            self.repo.db.query(AuditLog)
            .filter(AuditLog.target_user == username)
            .order_by(AuditLog.created_at.desc())
            .limit(100)
            .all()
        )

    # =====================================================
    # Online
    # =====================================================
    def online_users(self):
        return OcservService.online_users()

    def is_online(self, username):
        try:
            users = self.online_users()
            for user in users:
                name = (
                    user.get("Username")
                    or user.get("username")
                    or user.get("User")
                    or user.get("user")
                )
                if name == username:
                    return True
        except Exception:
            pass
        return False

    # =====================================================
    # Sessions
    # =====================================================
    def sessions(self, username):
        return OcservService.sessions(username)

    # =====================================================
    # Traffic
    # =====================================================
    def traffic(self, username):
        return OcservService.traffic(username)

    def traffic_usage(self, username):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        return OcservService.traffic(username)

    # =====================================================
    # Disconnect
    # =====================================================
    def disconnect(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        OcservService.disconnect_user(username)
        return True

    # =====================================================
    # Create
    # =====================================================
    def create(
        self,
        data,
        admin_username,
    ):
        if self.repo.get(data.username):
            raise Exception("Username already exists")
        OcservService.add_user(
            data.username,
            data.password,
        )
        user = VPNUser(
            username=data.username,
            password="",
            expire=data.expire,
            traffic=data.traffic,
            enabled=True,
            suspended=False,
            blocked=False,
            server_id=data.server_id,
            group_id=data.group_id,
        )
        self.repo.create(user)
        return user

    # =====================================================
    # Delete
    # =====================================================
    def delete(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        OcservService.delete_user(username)
        self.repo.delete(user)
        log_action(
            db=self.repo.db,
            admin="SYSTEM",
            target=username,
            action="DELETE USER",
            details="VPN user deleted",
        )

    # =====================================================
    # Enable / Disable
    # =====================================================
    def enable(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.enabled = True
        self.repo.update(user)
        return user

    def disable(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.enabled = False
        self.repo.update(user)
        return user

    # =====================================================
    # Suspend
    # =====================================================
    def suspend(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.suspended = True
        self.repo.update(user)
        return user

    def unsuspend(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.suspended = False
        self.repo.update(user)
        return user

    # =====================================================
    # Block
    # =====================================================
    def block(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.blocked = True
        self.repo.update(user)
        return user

    def unblock(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        user.blocked = False
        self.repo.update(user)
        return user

    # =====================================================
    # Password
    # =====================================================
    def change_password(
        self,
        username,
        password,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        OcservService.change_password(username, password)
        self.repo.set_password(username, "")

    # =====================================================
    # Expire
    # =====================================================
    def extend(
        self,
        username,
        expire,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        self.repo.set_expire(username, expire)
        log_action(
            db=self.repo.db,
            admin="SYSTEM",
            target=username,
            action="EXTEND USER",
            details=str(expire),
        )
        self.log_repo.create(
            username,
            "EXTEND",
            details=f"Expire -> {expire}",
        )

    # =====================================================
    # Traffic Reset
    # =====================================================
    def reset_traffic(
        self,
        username,
        admin_username,
    ):
        user = self.repo.get(username)
        if not user:
            raise Exception("User not found")
        self.repo.set_traffic(username, 0)
        self.log_repo.create(
            username,
            "TRAFFIC",
            details="Traffic reset",
        )
        return True
