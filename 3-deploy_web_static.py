#!/usr/bin/python3
"""
Fabric script that creates and distributes an archive to your web servers
"""

from fabric.api import env, local, run, put
from datetime import datetime
from os.path import exists

env.hosts = ['3.85.148.189', '54.87.195.116']


def do_pack():
    """
    Creates a compressed archive of the web_static folder
    """
    try:
        now = datetime.now().strftime("%Y%m%d%H%M%S")
        local("mkdir -p versions")
        local("tar -czvf versions/web_static_{}.tgz web_static".format(now))
        return "versions/web_static_{}.tgz".format(now)
    except Exception as e:
        return None


def do_deploy(archive_path):
    """
    Distributes an archive to your web servers
    """
    if not exists(archive_path):
        return False

    try:
        put(archive_path, "/tmp/")

        file_name = archive_path.split('/')[-1]
        folder_name = file_name.split('.')[0]
        run("mkdir -p /data/web_static/releases/{}".format(folder_name))
        run("tar -xzf /tmp/{} -C /data/web_static/releases/{}/"
            .format(file_name, folder_name))

        run("mv /data/web_static/releases/{}/web_static/* "
            "/data/web_static/releases/{}/".format(folder_name, folder_name))

        run("rm -rf /data/web_static/releases/{}/web_static".format(folder_name))
        run("rm /tmp/{}".format(file_name))
        run("rm -rf /data/web_static/current")
        run("ln -s /data/web_static/releases/{}/ /data/web_static/current".format(folder_name))
        return True
    except Exception as e:
        print("[{}] {}".format(env.host, e))
        return False


def deploy():
    """
    Deploy the web_static content to the web servers
    """
    archive_path = do_pack()
    if not archive_path:
        return False
    return do_deploy(archive_path)
