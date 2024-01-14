#!/usr/bin/python3
"""
Fabric script that distributes an archive to your web servers
"""

from fabric.api import env, put, run
from os.path import exists

env.hosts = ['web-01.botlhaledev.tech', 'web-02.botlhaledev.tech']
releases_path = '/data/web_static/releases'

def do_deploy(archive_path):
    """
    Distributes an archive to your web servers
    """
    if not exists(archive_path):
        return False
    
    try:
        # Upload the archive to the /tmp/ directory on the server
        put(archive_path, "/tmp/")

        file_name = archive_path.split('/')[-1]
        folder_name = file_name.split('.')[0]
        release_folder = "{}/{}".format(releases_path, folder_name)

        run("mkdir -p {}".format(release_folder))
        run("tar -xzf /tmp/{} -C {}".format(file_name, release_folder))

        # Move the contents of the web_static folder to the parent folder
        run("mv {}/web_static/* {}/".format(release_folder, release_folder))

        # Remove unnecessary directories and files
        run("rm -rf {}/web_static".format(release_folder))
        run("rm /tmp/{}".format(file_name))

        # Update the symbolic link
        run("rm -rf /data/web_static/current")
        run("ln -s {} /data/web_static/current".format(release_folder))

        return True

    except Exception as e:
        print("[{}] {}".format(env.host, e))
        return False
