#! /bin/bash

# Layer for kvmd's build dependencies

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install \
  dh-python \
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
  python3-pil \
  python3-stdeb \
  ustreamer

