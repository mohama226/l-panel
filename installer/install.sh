#!/bin/bash
set -e

echo "Installing L-Panel..."

# Update and install dependencies
apt update
apt install -y curl unzip python3 python3-pip python3-venv postgresql postgresql-contrib

# Start and enable PostgreSQL
echo "Starting PostgreSQL service..."
systemctl start postgresql.service
systemctl enable postgresql.service

# Create PostgreSQL database and user
echo "Creating PostgreSQL database and user..."
sudo -u postgres psql <<EOF
CREATE USER lpanel_user WITH PASSWORD 'lpanel_pass';
CREATE DATABASE lpanel OWNER lpanel_user;
GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel_user;
EOF

# Stop previous service if exists
systemctl stop l-panel 2>/dev/null || true

# Clean previous installation and download latest version
rm -rf /opt/l-panel
mkdir -p /opt
cd /tmp

echo "Downloading L-Panel..."
curl -L -o l-panel.zip \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip

unzip -o l-panel.zip
mv l-panel-main /opt/l-panel

# ========================
# بعد از کپی فایل‌ها — ایجاد محیط مجازی پایتون
# ========================
echo "Creating Python virtual environment..."
cd /opt/l-panel
python3 -m venv venv
/opt/l-panel/venv/bin/pip install --upgrade pip
/opt/l-panel/venv/bin/pip install -r requirements.txt

# ========================
# اجرای تنظیمات دیتابیس
# ========================
echo "Running database setup..."
cd /opt/l-panel
bash installer/setup_database.sh

# ========================
# مقداردهی اولیه دیتابیس
# ========================
echo "Initializing database..."
cd /opt/l-panel
/opt/l-panel/venv/bin/python3 -c "
from backend import create_app
app = create_app()
print('Database initialized')
" || echo "Warning: Database initialization command skipped or had issues."

# ========================
# تنظیم مجوزها و symlink
# ========================
chmod +x /opt/l-panel/installer/*.sh 2>/dev/null || true
chmod +x /opt/l-panel/scripts/* 2>/dev/null || true
ln -sf /opt/l-panel/scripts/l-panel /usr/local/bin/l-panel

echo "L-Panel files installed successfully."

# ========================
# ایجاد فایل سرویس systemd
# ========================
echo "Creating systemd service file..."

cat > /etc/systemd/system/l-panel.service << 'EOL'
[Unit]
Description=L-Panel Service
After=network.target postgresql.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/l-panel
ExecStart=/opt/l-panel/venv/bin/python3 -m gunicorn --bind 0.0.0.0:5000 --workers 2 backend:app
Restart=always
Environment=FLASK_ENV=production
Environment=PYTHONPATH=/opt/l-panel

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and start service
systemctl daemon-reload
systemctl enable l-panel
systemctl restart l-panel

echo "=========================================="
echo "L-Panel Installed and Started Successfully!"
echo "=========================================="
echo "Service status: systemctl status l-panel"
echo "Logs: journalctl -u l-panel -f"
echo "Default port: 5000"
