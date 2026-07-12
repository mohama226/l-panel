#!/bin/bash


APP_PATH="/opt/lak-panel"


cat > /etc/systemd/system/lak-panel.service <<EOF

[Unit]
Description=LAK Panel
After=network.target


[Service]

User=root

WorkingDirectory=$APP_PATH/backend

EnvironmentFile=$APP_PATH/.env

ExecStart=$APP_PATH/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port \$APP_PORT

Restart=always


[Install]

WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel
