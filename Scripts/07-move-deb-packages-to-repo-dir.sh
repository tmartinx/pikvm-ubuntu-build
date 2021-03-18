#! /bin/bash

# Move all Debian packages built locally to a common directory.

mkdir -p ~/apt/ubuntu/dists/focal/main/binary-arm64/
mkdir -p ~/apt/ubuntu/pool/main

find ~/sources/ -type f -name "*.deb" -exec mv -t ~/apt/ubuntu/pool/main/ {} +
