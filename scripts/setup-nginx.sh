#!/usr/bin/env bash

set -e


yum install -y nginx


mkdir -p /etc/nginx/conf.d


cp /opt/l-panel/nginx/l-panel.conf \
/etc/nginx/conf.d/l-panel.conf



nginx -t


systemctl enable nginx

systemctl restart nginx
