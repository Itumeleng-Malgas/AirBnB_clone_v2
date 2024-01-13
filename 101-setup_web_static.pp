# File: 101-setup_web_static.pp

# Install Nginx if not already installed
package { 'nginx':
  ensure => installed,
}

# Create necessary directories
file { ['/data', '/data/web_static', '/data/web_static/releases', '/data/web_static/shared', '/data/web_static/releases/test']:
  ensure => directory,
}

# Create a fake HTML file
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  content => '<html><body>Hello, this is a test page!</body></html>',
}

# Create a symbolic link
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test',
}

# Give ownership of /data/ folder to ubuntu user and group
file { '/data':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
}

# Update Nginx configuration
file { '/etc/nginx/sites-available/default':
  content => template('nginx/default.erb'),
  notify  => Service['nginx'],
}

# Define Nginx service
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => File['/etc/nginx/sites-available/default'],
}

# Define firewall rules for Nginx
exec { 'allow_nginx':
  command => '/sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT',
  unless  => '/sbin/iptables -nL | grep -q "ACCEPT.*tcp.*dpt:80"',
  require => Service['nginx'],
}

# Reload the firewall
exec { 'reload_firewall':
  command => '/sbin/iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT && /sbin/iptables-save > /etc/sysconfig/iptables',
  unless  => '/sbin/iptables -nL | grep -q "ACCEPT.*tcp.*dpt:22"',
  subscribe => Exec['allow_nginx'],
}
