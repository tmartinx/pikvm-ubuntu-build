#! /bin/bash

#
# Debian Base Layer
#


export DEBIAN_FRONTEND=noninteractive


# The DEFAULT_USER setup
if [ -z "$DEFAULT_USER" ]
then
    echo "*** ABORTING! DEFAULT_USER variable not set."
    exit 1
fi


# First Update
apt-get update

# Install basic packages
apt-get -y install apt-utils sudo dialog


if id -u $DEFAULT_USER &> /dev/null
then
    echo "*** WARNING! DEFAULT_USER already exist, skipping user creation."
else
    echo "*** The DEFAULT_USER doesn't exist, creating it."
    # Create a regular user for the build process
    useradd -ms /bin/bash $DEFAULT_USER
    usermod -a -G sudo $DEFAULT_USER

    # Configure memebers of sudo group to become root without password
    echo "%sudo   ALL=NOPASSWD:ALL" > /etc/sudoers.d/sudo-group
fi

# Create a subdir for the sources
if [ ! -d /home/$DEFAULT_USER/sources ]
then
    su - $DEFAULT_USER -c 'mkdir ~/sources'
fi

# Install Python, build tools and tools lol
apt-get -y install python3 python-is-python3 python3-setuptools gnupg build-essential dpkg-dev wget
