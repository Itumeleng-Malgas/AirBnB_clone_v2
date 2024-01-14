#!/usr/bin/env bash
# Sets up webservers for deployment of web_static

if ! command -v nginx &> /dev/null; then
    apt -y update
    apt -y install nginx
    ufw allow 'Nginx HTTP'
fi

mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

html_content="<!DOCTYPE html><html><body>Hello world!</body></html>"
echo -e "$html_content" | tee /data/web_static/releases/test/index.html

if [ -d "/data/web_static/current/" ]; then
    rm -rf /data/web_static/current/
fi

ln -sf /data/web_static/releases/test/ /data/web_static/current/
chown -R ubuntu:ubuntu /data/

sudo sed -i "/server_name .*;/a\ location /hbnb_static { alias /data/web_static/current;}" /etc/nginx/sites-enabled/default

service nginx restart
