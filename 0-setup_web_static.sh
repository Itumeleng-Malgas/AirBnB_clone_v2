#!/bin/bash

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

    error_page 404 /404.html;
    location = /404.html {
        root /usr/share/nginx/html;
        internal;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
        internal;
    }
}
EOL
)

echo "$config_content" | sudo tee /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart

exit 0
