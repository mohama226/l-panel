#!/usr/bin/env bash


blue "Creating Systemd Service..."


cat > /etc/systemd/system/l-panel.service <<EOF

[Unit]

Description=L-Panel VPN Management Panel

After=network.target



[Service]

User=root

WorkingDirectory=/opt/l-panel/backend

EnvironmentFile=/etc/l-panel/.env

ExecStart=/opt/l-panel/backend/venv/bin/gunicorn app.main:app \
-k uvicorn.workers.UvicornWorker \
--bind 0.0.0.0:${PANEL_PORT}



Restart=always



[Install]

WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable l-panel

systemctl restart l-panel


green "Service Started."
