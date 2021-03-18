#! /bin/bash

# Layer for stdeb (to build the debian/ files to make the package)

sudo DEBIAN_FRONTEND=noninteractive apt-get -y build-dep stdeb

mkdir ~/sources/stdeb

pushd ~/sources/stdeb

apt-get source stdeb

pushd stdeb-0.10.0

dpkg-buildpackage -rfakeroot -uc -us -j4

popd

sudo dpkg -i python3-stdeb_0.10.0-1_all.deb

popd
