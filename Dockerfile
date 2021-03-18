FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

ENV TERM linux

ENV DEFAULT_USER kvmd-builder

COPY Scripts/01-ubuntu-initial-setup.sh /tmp
RUN /tmp/01-ubuntu-initial-setup.sh

USER kvmd-builder

COPY Scripts/02-build-libjpeg-turbo.sh /tmp
RUN /tmp/02-build-libjpeg-turbo.sh

COPY Scripts/03-build-ustreamer.sh /tmp
RUN /tmp/03-build-ustreamer.sh

COPY Scripts/04-build-stdeb.sh /tmp
RUN /tmp/04-build-stdeb.sh

COPY Scripts/05-kvmd-ubuntu-dependencies.sh /tmp
RUN /tmp/05-kvmd-ubuntu-dependencies.sh

COPY Scripts/06-build-kvmd.sh /tmp
RUN /tmp/06-build-kvmd.sh

COPY Scripts/07-move-deb-packages-to-repo-dir.sh /tmp
RUN /tmp/07-move-deb-packages-to-repo-dir.sh

COPY Scripts/08-apt-sync-local-repo.sh /tmp
RUN /tmp/08-apt-sync-local-repo.sh

#COPY Scripts/09-apt-nginx-config.sh /tmp
#RUN /tmp/09-apt-nginx-config.sh

WORKDIR /home/$DEFAULT_USER
