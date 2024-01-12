#!/usr/bin/python3
"""
Fabric script that distributes an archive to your web servers
"""

from fabric.api import env, put, run, local
from os.path import exists

env.hosts = ['3.85.148.189', '54.87.195.116']


def do_deploy(archive_path):
    """
    Distributes an archive to your web servers
    """
    if not exists(archive_path):
        return False

    try:
        # Upload the archive to the /tmp/ directory
        put(archive_path, "/tmp/")

        # Extract the archive to /data/web_static/releases/<archive
        # filename without extension>
        file_name = archive_path.split('/')[-1]
        folder_name = file_name.split('.')[0]
        run("mkdir -p /data/web_static/releases/{}".format(folder_name))
        run("tar -xzf /tmp/{} -C /data/web_static/releases/{}/"
            .format(file_name, folder_name))

        # Move contents to /data/web_static/releases/<archive
        # filename without extension>
        run("mv /data/web_static/releases/{}/web_static/* "
            "/data/web_static/releases/{}/".format(folder_name, folder_name))

        # Delete the extracted folder
        run("rm -rf /data/web_static/releases/{}/web_static"
            .format(folder_name))

        # Delete the archive from the web server
        run("rm /tmp/{}".format(file_name))

        # Delete the symbolic link /data/web_static/current
        run("rm -rf /data/web_static/current")

        # Create a new symbolic link /data/web_static/current
        run("ln -s /data/web_static/releases/{}/ /data/web_static/current"
            .format(folder_name))

        return True

    except Exception as e:
        print("[{}] {}".format(env.host, e))
        return False
