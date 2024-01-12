#!/usr/bin/python3
"""
Fabric script that deletes out-of-date archives
"""

from fabric.api import env, run, local
from datetime import datetime
from os.path import exists

env.hosts = ['3.85.148.189', '54.87.195.116']


def do_clean(number=0):
    """
    Deletes out-of-date archives
    """
    try:
        number = int(number)
        if number < 1:
            number = 1
        else:
            number += 1

        # Delete unnecessary archives in the versions folder
        local("ls -t versions/ | tail -n +{} | xargs -I {{}} rm versions/{{}}"
              .format(number))

        # Delete unnecessary archives in the /data/web_static/releases folder
        run("ls -t /data/web_static/releases/ | tail -n +{} | xargs -I {{}}"
            "rm -rf /data/web_static/releases/{{}}".format(number))

        return True

    except Exception as e:
        print("[{}] {}".format(env.host, e))
        return False
