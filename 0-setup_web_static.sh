#!/usr/bin/env bash
# Sets up webservers for deployment of web_static

# Install nginx if not installed
if ! command -v nginx &> /dev/null; then
    apt -y update
    apt -y install nginx
fi

ufw allow 'Nginx HTTP'

# Directories
mkdir -p /data/web_static/releases/test/ /data/web_static/shared/

# HTML content
html_content="<!DOCTYPE html><html><body>Hello world!</body></html>"

# Create a simple HTML file for testing
echo -e "$html_content" | sudo tee /data/web_static/releases/test/index.html

ln -sf /data/web_static/releases/test/ /data/web_static/current/

# Ensure correct permissions
chown -R ubuntu:ubuntu /data/

# Configure Nginx to serve the static content
config_str=$'\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}\n'
sed -i "/server_name .*;/a$config_str" /etc/nginx/sites-available/default

# Enable Nginx site configuration
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled

# Reload Nginx to apply changes
service nginx reload
