#!/bin/bash


BASE="/opt/lak-panel"


source $BASE/installer/functions.sh


title "Installing Backup System"


mkdir -p $BASE/backup/backups


chmod 700 $BASE/backup/backups



cat > $BASE/backup/backup.sh <<'EOF'

#!/bin/bash


BASE="/opt/lak-panel"

DATE=$(date +"%Y-%m-%d_%H-%M")


mkdir -p $BASE/backup/backups



tar -czf \
$BASE/backup/backups/lak-panel-$DATE.tar.gz \
$BASE/panel \
$BASE/config \
/etc/systemd/system/lak-panel.service



echo

echo "Backup created:"
echo

echo "$BASE/backup/backups/lak-panel-$DATE.tar.gz"


EOF



chmod +x $BASE/backup/backup.sh



(crontab -l 2>/dev/null; echo "0 3 * * * $BASE/backup/backup.sh") | crontab -



success "Backup system installed"
