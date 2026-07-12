#!/bin/bash


BASE="/opt/lak-panel"

source $BASE/installer/functions.sh


title "Installing LAK PANEL"


mkdir -p $BASE/panel/backend


cd $BASE/panel/backend



python3 -m venv venv


source venv/bin/activate


pip install --upgrade pip


if [ -f requirements.txt ]
then

pip install -r requirements.txt

fi



mkdir -p $BASE/panel/backend/app/templates

mkdir -p $BASE/panel/backend/app/static



cat > /etc/systemd/system/lak-panel.service <<EOF

[Unit]
Description=LAK Panel
After=network.target


[Service]

WorkingDirectory=$BASE/panel/backend

Environment=PYTHONUNBUFFERED=1

ExecStart=$BASE/panel/backend/venv/bin/python3 $BASE/panel/backend/run.py

Restart=always

RestartSec=5

User=root


[Install]

WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable lak-panel



cat > /usr/local/bin/lak-panel <<EOF
#!/bin/bash
bash $BASE/installer/menu.sh
EOF


chmod +x /usr/local/bin/lak-panel



success "Panel service created"
