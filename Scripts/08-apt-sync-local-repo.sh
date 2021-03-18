#! /bin/bash

# Build Packages.gz, creating a file to make this an APT Repository

pushd ~/apt/ubuntu

dpkg-scanpackages pool | gzip -9c > dists/focal/main/binary-arm64/Packages.gz

popd
