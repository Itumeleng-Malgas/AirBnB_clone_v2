#!/usr/bin/env bash
# Sets up webservers for deployment of web_static

# Install nginx if it is not installed already
apt -y update
apt -y install nginx

ufw allow 'Nginx HTTP'

# Create necessary directories
mkdir -p /data/web_static/releases/test
mkdir -p /data/web_static/shared

# Create a fake HTML file
html_content="<html><head></head><body>Holberton School</body></html>"
echo "$html_content" | sudo tee /data/web_static/releases/test/index.html

# Symbolic link /data/web_static/current to /data/web_static/releases/test
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Giving ownership to user ubuntu
chown -R ubuntu:ubuntu /data/

# Serve the content of /data/web_static/current/ at /hbnb_static
conf="
\tlocation /hbnb_static {
\t\talias /data/web_static/current/;
\t}
"
sed -i "/servername .*;/a\ $conf" /etc/nginx/sites-available/default

# Link site-available with site-enabled
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled
service nginx restart
