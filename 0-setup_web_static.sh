#!/usr/bin/env bash
# Sets up webservers for deployment of web_static

apt -y update && apt -y install nginx
ufw allow 'Nginx HTTP'

mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

echo "Hello world!" | sudo tee /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current

chown -R ubuntu:ubuntu /data/

nginx_config="
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;
    
    location /hbnb_static {
        alias /data/web_static/current/;
    }
}
"
echo -e "$nginx_config" | sudo tee /etc/nginx/sites-available/default > /dev/null

ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled
sudo service nginx reload
