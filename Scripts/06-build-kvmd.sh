#! /bin/bash

# Layer 7 - kvmd build/package

mkdir ~/sources/kvmd

pushd ~/sources/kvmd

wget https://github.com/pikvm/kvmd/archive/v2.33.tar.gz

mv v2.33.tar.gz kvmd-2.33.tar.gz

py2dsc --with-dh-systemd --compat 10 kvmd-2.33.tar.gz

pushd ~/sources/kvmd/deb_dist/kvmd-2.33

dpkg-buildpackage -rfakeroot -uc -us -j4

popd

popd

# FIXME: The auto-generated Debian package for kvmd doesn't contain the right
# "Build-Depends/Depends" entries.
