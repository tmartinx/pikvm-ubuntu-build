#! /bin/bash

#
# Ubuntu Layer
#
# Ubuntu, Victoria (needed for debhelper, cmake, etc), and Debian Testing,
# needed for libjpeg-turbo, ustreamer and stdeb.
#


export DEBIAN_FRONTEND=noninteractive


# The DEFAULT_USER setup
if [ -z "$DEFAULT_USER" ]
then
    echo "*** ABORTING! DEFAULT_USER variable not set."
    exit 1
fi

if id -u $DEFAULT_USER > /dev/null
then
    echo "*** WARNING! DEFAULT_USER already exists, not creating it again."
else
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


# First Update
apt-get update

# Install basic packages
apt-get -y install apt-utils sudo dialog

# Install Ubuntu Cloud Archive Keyring and build tools
apt-get -y install ubuntu-cloud-keyring gnupg build-essential dpkg-dev wget

# Add Ubuntu Cloud Archive and Debian Testing source repository
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu focal-updates/victoria main" > /etc/apt/sources.list.d/cloudarchive-victoria.list
echo "deb-src http://deb.debian.org/debian testing main" > /etc/apt/sources.list.d/debian.list

# Get Debian Keys
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138

# Second Update
apt-get update

# Install Python basic packages
apt-get -y install python3 python-is-python3 python3-setuptools
