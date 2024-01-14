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

# Serve the content of /data/web_static/current/ at /hbnb_static
conf="
\tlocation /hbnb_static {
\t\talias /data/web_static/current/;
\t}
"
sed -i "/servername ;/a $conf" /etc/nginx/sites-available/default

# Link site-available with site-enabled
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled

service nginx restart
