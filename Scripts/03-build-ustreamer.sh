#! /bin/bash

# Layer for ustreamer (kvmd's dependency)

sudo DEBIAN_FRONTEND=noninteractive apt-get -y build-dep ustreamer

mkdir ~/sources/ustreamer

pushd ~/sources/ustreamer

apt-get source ustreamer

pushd ustreamer-3.16

dpkg-buildpackage -rfakeroot -uc -us -j4

popd

sudo dpkg -i ustreamer_3.16-1_arm64.deb

popd
