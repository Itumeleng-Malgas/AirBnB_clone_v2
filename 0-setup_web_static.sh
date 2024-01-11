#!/usr/bin/env bash
"""
Sets up webservers for deployment of web_static

"""

# Install nginx if it is not installed already
if command -v nginx &> /dev/null; then
	apt -y update && apt -y install nginx
fi

# Create necessary directories
mkdir -p /data/web_static/releases/test
mkdir -p /data/web_static/shared

# Create a fake HTML file
echo "<html><head></head><body>Holberton School</body></html>" |
	sudo tee /data/web_static/releases/test/index.html

# Symbolic link /data/web_static/current to /data/web_static/releases/test
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Giving ownership to user ubuntu
chown -R ubuntu:ubuntu /data/

# Serve the content of /data/web_static/current/ at /hbnb_static
config_str="\n\tlocation /hbnb_static {\n\t\t alias /data/web_static/current/;\n\t}"

sed -i "/servername ;/a\ $config_str" /etc/nginx/sites-available/default


# Link site-available with site-enabled
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled

# Restart nginx
service nginx restart
