#!/usr/bin/env bash
# Sets up webservers for deployment of web_static

# Install nginx if it is not installed already
apt -y update && apt -y install nginx

ufw allow 'Nginx HTTP'

# Create necessary directories
mkdir -p /data/
mkdir -p /data/web_static/
mkdir -p /data/web_static/releases/
mkdir -p /data/web_static/shared
mkdir -p /data/web_static/releases/test

# Create a fake HTML file
echo "Hello world!" | sudo tee /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Giving ownership to user ubuntu
chown -R ubuntu:ubuntu /data/

conf="
\tlocation /hbnb_static {
\t\talias /data/web_static/current/;
\t}
"
sed -i "/servername .*;/a\ $conf" /etc/nginx/sites-available/default
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled

service nginx restart
