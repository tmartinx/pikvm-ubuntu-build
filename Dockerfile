# Layer 1 - Ubuntu Rocks!

FROM ubuntu:20.04

RUN useradd -ms /bin/bash pikvmd-builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install apt-utils

# Layer 2 - Ubuntu, Victoria (needed for debhelper, cmake, etc), and Debian
# Testing (needed for libjpeg-turbo, ustreamer and stdeb).

RUN apt-get -y install ubuntu-cloud-keyring gnupg build-essential dpkg-dev wget \
    && echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu focal-updates/victoria main" > /etc/apt/sources.list.d/uca.list \
    && echo "deb-src http://deb.debian.org/debian testing main" > /etc/apt/sources.list.d/debian.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 \
    && apt-get update \
    && apt-get -y install python3 python-is-python3 python3-setuptools


# Layer 3 - libjpeg-turbo (ustream's dependency)

RUN apt-get -y build-dep libjpeg-turbo \
    && mkdir /root/libjpeg-turbo \
    && cd /root/libjpeg-turbo \
    && apt-get source libjpeg-turbo \
    && cd libjpeg-turbo-2.0.6 \
    && dpkg-buildpackage -rfakeroot -uc -us -j4 \
    && cd .. \
    && dpkg -i libjpeg62-turbo-dev_2.0.6-2_arm64.deb libjpeg62-turbo_2.0.6-2_arm64.deb


# Layer 4 - ustreamer (pikvmd's dependency)

RUN apt-get -y build-dep ustreamer \
    && mkdir /root/ustreamer \
    && cd /root/ustreamer \
    && apt-get source ustreamer \
    && cd ustreamer-3.16 \
    && dpkg-buildpackage -rfakeroot -uc -us -j4 \
    && cd .. \
    && dpkg -i ustreamer_3.16-1_arm64.deb


# Layer 5 - stdeb (to build the debian/ files to make the package)

RUN apt-get -y build-dep stdeb \
    && mkdir /root/stdeb \
    && cd /root/stdeb \
    && apt-get source stdeb \
    && cd stdeb-0.10.0 \
    && dpkg-buildpackage -rfakeroot -uc -us -j4 \
    && cd .. \
    && dpkg -i python3-stdeb_0.10.0-1_all.deb


# Layer 6 - Pi-KVM's Build Dependencies - WARNING! Not declared later on at its auto-generated debian/control file!

RUN apt-get update \
    && apt-get -y install \
       python3-pygments \
       python3-psutil \
       python3-setproctitle \
       python3-aiofiles \
       python3-yaml \
       python3-libgpiod \
       python3-passlib \
       python3-aiohttp \
       python3-dbus \
       python3-serial \
       python3-systemd \
       python3-xlib \
       python3-pyghmi \
       python3-pil


# Layer 7 - kvmd build/package

RUN mkdir /root/kvmd \
    && cd /root/kvmd \
    && wget https://github.com/pikvm/kvmd/archive/v2.33.tar.gz \
    && mv v2.33.tar.gz kvmd-2.33.tar.gz \
    && py2dsc --with-dh-systemd --compat 10 kvmd-2.33.tar.gz \
    && cd /root/kvmd/deb_dist/kvmd-2.33 \
    && dpkg-buildpackage -rfakeroot -uc -us -j4

