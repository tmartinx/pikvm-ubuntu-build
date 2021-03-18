#! /bin/bash

# Install NGINX to host the local APT Repository

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install nginx-core

# FIXME: Come up with a better way of sharing it, no init system inside of Docker to keep serving the APT Repo... lol
