#!/usr/bin/env bash
# Sets up web servers for the deployment of web_static

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test
sudo mkdir -p /data/web_static/shared

# Create a fake HTML file
echo "<html><head></head><body>Holberton School</body></html>" |
	sudo tee /data/web_static/releases/test/index.html

# Create or recreate symbolic link
sudo ln -sf /data/web_static/releases/test /data/web_static/current

# Give ownership to the ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_content=$(cat <<EOL
server {
    listen 80;
    server_name _;

    location /hbnb_static {
        alias /data/web_static/current;
    }

    location / {
        add_header X-Served-By $HOSTNAME;
        #proxy_pass http://0.0.0.0:5000;

	index index.html;
    }
}
EOL
)

echo "$config_content" | sudo tee /etc/nginx/sites-available/default

# Enable new configs by linking site-available with site-enabled
ln -sf /etc/nginx/site-available/default /etc/nginx/site-enabled

# Restart Nginx
sudo service nginx restart

exit 0
