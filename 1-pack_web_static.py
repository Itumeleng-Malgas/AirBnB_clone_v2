#!/usr/bin/python3
"""
Generate a .tgz archive module
"""

from fabric.api import local
from datetime import datetime
import os


def do_pack():
    """
    Generate a .tgz archive from the contents of the web_static folder.

    Returns:
        str: Archive path if generated successfully, None otherwise.
    """

    if not os.path.exists("versions"):
        local("mkdir -p versions")

    timestamp = datetime.utcnow().strftime('%Y%m%d%H%M%S')
    archive_name = "web_static_{}.tgz".format(timestamp)

    tar_command = "tar -czvf versions/{} web_static".format(archive_name)
    result = local(tar_command)

    if result.succeeded:
        return os.path.join("versions", archive_name)
    else:
        return None
