#!/usr/bin/python3
"""
enerate a .tgz archive module
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
    # Create the versions folder if it doesn't exist
    if not os.path.exists("versions"):
        local("mkdir -p versions")

    # Create the archive name using the current date and time
    timestamp = datetime.utcnow().strftime('%Y%m%d%H%M%S')
    archive_name = "web_static_{}.tgz".format(timestamp)

    # Create the tar command
    tar_command = "tar -czvf versions/{} web_static".format(archive_name)

    # Execute the tar command
    result = local(tar_command)

    # Check if the archive was created successfully
    if result.succeeded:
        return os.path.join("versions", archive_name)
    else:
        return None
