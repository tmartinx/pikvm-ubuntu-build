#! /bin/bash

#
# Ubuntu Layer
#
# Ubuntu, Victoria (needed for debhelper, cmake, etc), and Debian Testing,
# needed for libjpeg-turbo, ustreamer and stdeb.
#

export DEBIAN_FRONTEND=noninteractive

# First Update
apt-get update

# Install basic packages
apt-get -y install apt-utils sudo dialog

# Create a regular user to build and package kvmd
useradd -ms /bin/bash kvmd-builder
usermod -a -G sudo kvmd-builder

# Configure memebers of sudo group to become root without password
echo "%sudo   ALL=NOPASSWD:ALL" > /etc/sudoers.d/sudo-group

# Install Ubuntu Cloud Archive Keyring and build tools
apt-get -y install ubuntu-cloud-keyring gnupg build-essential dpkg-dev wget

# Add Ubuntu Cloud Archive and Debian Testing source repository
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu focal-updates/victoria main" > /etc/apt/sources.list.d/uca.list
echo "deb-src http://deb.debian.org/debian testing main" > /etc/apt/sources.list.d/debian.list

# Get Debian Keys
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138

# Second Update
apt-get update

# Install Python basic packages
apt-get -y install python3 python-is-python3 python3-setuptools

# Create a subdir for the sources
su - kvmd-builder -c 'mkdir ~/sources'
