#!/usr/bin/env bash
# Sets up webservers for deployment of web_static

apt -y update && apt -y install nginx
ufw allow 'Nginx HTTP'

mkdir -p /data/web_static/releases/test
mkdir -p /data/web_static/shared

echo "Hello world!" | sudo tee /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current

chown -R ubuntu:ubuntu /data/

config_str="\n\tlocation /hbnb_static {\n\t\t alias /data/web_static/current/;\n\t}"
sed -i "/servername .*;/a\ $config_str" /etc/nginx/sites-available/default

ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled
service nginx restart
