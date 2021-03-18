#! /bin/bash

# Layer for libjpeg-turbo (ustream's dependency)

sudo DEBIAN_FRONTEND=noninteractive apt-get -y build-dep libjpeg-turbo

mkdir ~/sources/libjpeg-turbo

pushd ~/sources/libjpeg-turbo

apt-get source libjpeg-turbo

pushd libjpeg-turbo-2.0.6

dpkg-buildpackage -rfakeroot -uc -us -j4

popd

sudo dpkg -i libjpeg62-turbo-dev_2.0.6-2_arm64.deb libjpeg62-turbo_2.0.6-2_arm64.deb

popd
