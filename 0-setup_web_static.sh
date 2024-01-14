#!/usr/bin/env bash
# Sets up webservers for deployment of web_static

# Check if nginx is installed, and install it if not
if ! command -v nginx &> /dev/null; then
    apt -y update
    apt -y install nginx
    ufw allow 'Nginx HTTP'
fi

# Create necessary directories
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

# Create a simple HTML file for testing
echo "Hello world!" | sudo tee /data/web_static/releases/test/index.html

# Create a symbolic link to the 'test' release
ln -sf /data/web_static/releases/test/ /data/web_static/current/

# Ensure correct permissions
chown -R ubuntu:ubuntu /data/

# Configure Nginx to serve the static content
config_str=$'\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}\n'
sed -i "/server_name .*;/a$config_str" /etc/nginx/sites-available/default

# Create a symbolic link to enable the default site configuration
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled

# Reload Nginx to apply changes
service nginx reload
