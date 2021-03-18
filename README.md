# pikvm-ubuntu-build

Pi-KVM Ubuntu-based Experimental Build

*NOTE: This is a community build and not officially supported, no guarantee to even work!*

Requirements:

* Ubuntu Server 20.04 arm64
* Raspberry Pi4 4GB of RAM

NOTE: It should work with 2GB of RAM if you change the "-j4" to "-j2" within the build scripts)

## Prepare your Ubuntu Server 20.04 Bare-Metal

First, prepare your Ubuntu bare-metal, by running:

    sudo apt update
    sudo apt full-upgrade # Optional
    sudo apt install zram-config # Free RAM! lol - Optional
    sudo apt install linux-generic-hwe-20.04 # Creepy new Linux - Optional
    sudo apt install git

Clone this repo and build Pi-KVMD Debian package for Ubuntu 20.04!

    cd ~
    git clone https://github.com/tmartinx/pikvmd-ubuntu-build

## Building kvmd on Docker Container

NOTE: THIS IS A PROTOTYPE!

### Ubuntu Server 20.04 Container

Install Docker

NOTE: This procedure assumes that your Ubuntu's `default_user` is called `ubuntu`.

    sudo apt install docker.io
    sudo adduser ubuntu docker

Logoff and login again (so `ubuntu` user can use Docker).

Building `kvmd`!

    cd ~/pikvmd-ubuntu-build
    docker build -f Dockerfile.focal -t pikvm-build-1 .

After this process, which takes about 9 minutes, you'll have a APT repository with the packages necessary to install Pi-KVMD on virtually any Ubuntu Server 20.04!

### Debian 11 (Testing) Container

Install Docker

NOTE: This procedure assumes that your Debian's `default_user` is called `debian`.

    sudo apt install docker.io
    sudo adduser debian docker

Logoff and login again (so `debian` user can use Docker).

Building `kvmd`!

    cd ~/pikvmd-ubuntu-build
    docker build -f Dockerfile.bullseye -t pikvm-build-2 .

After this process, which takes about 5 minutes, you'll have a APT repository with the packages necessary to install Pi-KVMD on virtually any Ubuntu Server 20.04!

### Accessing the container

To create/start a container and see what's in there (and maybe copy the files to your Bare-Metal Ubuntu):

    docker run -ti pikvm-build-1 /bin/bash   # or "pikvm-build-2", or "whatever-name-you-created-previsouly-x"...

### Cleaning up Docker stuff

To wipe out Docker images and containers (clean up your small micro SD)

    docker system prune -a

## Building kvmd on Ubuntu Server 20.04 Bare-Metal

The following procedure uses the very same Bash scripts that the `Dockerfile.focal` used previously but, you're supposed to run those directly in your Raspberry Pi4 bare-metal.

You'll need to run those scripts with a regular Ubuntu user with `sudo` powers!

NOTE: This procedure assumes that your Ubuntu's `default_user` is called `ubuntu`.

    cd ~/pikvmd-ubuntu-build

    sudo DEFAULT_USER=ubuntu ./Scripts/01-ubuntu-initial-setup.sh

    Scripts/02-build-libjpeg-turbo.sh
    Scripts/03-build-ustreamer.sh
    Scripts/04-build-stdeb.sh
    Scripts/05-kvmd-ubuntu-dependencies.sh
    Scripts/06-build-kvmd.sh
    Scripts/07-move-deb-packages-to-repo-dir.sh
    Scripts/08-apt-sync-local-repo.sh

After this process, the `kvmd` will be available at `~/apt/ubuntu/pool/main/python3-kvmd_2.33-1_all.deb`!!!

NOTE: Take a look at the Dockerfile.bullseye to see the required steps to build it on an Bare-Metal Debian.

## The local APT repository

The procedure builds a local APT repository for you! To use it, you'll have to add it to your `/etc/apt/sources.list.d` subdir.

    echo "deb [trusted=yes] file:///home/ubuntu/apt/ubuntu focal main" | sudo tee -a /etc/apt/sources.list.d/pikvm.list

Then:

    sudo apt update
    sudo apt install python3-kvmd

NOTE: The procedure for Debian is similar but not ready yet!

## The Pi-KVM Build and Runtime Dependencies

First of all, this is an experimental prototype!

The main problem with this is that the `kvmd` dependencies are incomplete within the generated `python3-kvmd_2.33-1_all.deb` pacakge!

The build dependencies are actually being manually installed with the `Scripts/05-kvmd-ubuntu-dependencies.sh`.

The runtime dependencies aren't being installed at all! The runtime was not tested yet! Just the build process of the `kvmd` itself.

The `kvmd` package's `debian/control` file and everything else related to the Debian packaging is auto-generated with the `stdeb` solution, this is done at the `Scripts/06-build-kvmd.sh`.

There might be a standard way (maybe still using the `stdeb` solution) to include all the required build and runtime dependencies into the `debian/control` file.

### Extra dependencies

During the initial tests, for the simplicity's sake, the following dependencies where removed, and the build process still worked!

    libevent-dev
    libbsd-dev
    python3-mako
    python3-pam
    python3-hidapi

There is also an interesting piece of software on Ubuntu, called `python3-serial-asyncio`, could it improve `kvmd` somehow, since it depends on `python3-serial` and the `asyncio` version sounds cool?

More investigation is required to fully understand everything from the pikvm/kvmd source code!
