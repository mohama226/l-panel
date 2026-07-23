import os

BASE_DIR = os.path.abspath(os.path.dirname(__file__))

#
# General
#

APP_NAME = "L-PANEL"

APP_VERSION = "1.0.0"

DEBUG = False

SECRET_KEY = os.getenv(
    "LPANEL_SECRET_KEY",
    "CHANGE_ME"
)

#
# Database
#

DB_HOST = os.getenv("LPANEL_DB_HOST", "127.0.0.1")

DB_PORT = os.getenv("LPANEL_DB_PORT", "5432")

DB_NAME = os.getenv("LPANEL_DB_NAME", "lpanel")

DB_USER = os.getenv("LPANEL_DB_USER", "lpanel")

DB_PASSWORD = os.getenv(
    "LPANEL_DB_PASSWORD",
    "CHANGE_ME"
)

SQLALCHEMY_DATABASE_URI = (

    f"postgresql://"

    f"{DB_USER}:{DB_PASSWORD}"

    f"@{DB_HOST}:{DB_PORT}"

    f"/{DB_NAME}"

)

SQLALCHEMY_TRACK_MODIFICATIONS = False

#
# Redis
#

REDIS_HOST = os.getenv(
    "LPANEL_REDIS_HOST",
    "127.0.0.1"
)

REDIS_PORT = int(
    os.getenv(
        "LPANEL_REDIS_PORT",
        "6379"
    )
)

#
# Backend
#

HOST = "127.0.0.1"

PORT = 8000

#
# Frontend
#

FRONTEND_DIST = "/opt/l-panel/frontend/dist"

#
# Ocserv
#

OCSERV_INFO = "/etc/l-panel/ocserv.info"

OCSERV_CONFIG = "/etc/ocserv/ocserv.conf"

OCPASSWD = "/etc/ocserv/ocpasswd"

OCCTL = "/usr/bin/occtl"

#
# Logs
#

LOG_DIR = "/var/log/l-panel"

#
# Backup
#

BACKUP_DIR = "/opt/l-panel/backups"
