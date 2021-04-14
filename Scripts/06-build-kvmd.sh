#! /bin/bash

# Layer 7 - kvmd build/package

PIKVM_VERSION="2.42"

mkdir ~/sources/kvmd

pushd ~/sources/kvmd

wget https://github.com/pikvm/kvmd/archive/v${PIKVM_VERSION}.tar.gz

mv v${PIKVM_VERSION}.tar.gz kvmd-${PIKVM_VERSION}.tar.gz

py2dsc --with-dh-systemd --compat 10 kvmd-${PIKVM_VERSION}.tar.gz

pushd ~/sources/kvmd/deb_dist/kvmd-${PIKVM_VERSION}

dpkg-buildpackage -rfakeroot -uc -us -j4

popd

popd

# FIXME: The auto-generated Debian package for kvmd doesn't contain the right
# "Build-Depends/Depends" entries.
