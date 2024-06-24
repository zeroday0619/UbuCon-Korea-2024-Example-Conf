#!/bin/sh

## Install lxd
snap list lxd &> /dev/null && sudo snap refresh lxd --channel latest/stable || sudo snap install lxd --channel latest/stable

## Configure LXD
sudo lxd init --auto

## Install and configure Landscape

### Step 1
sudo lxc launch ubuntu:24.04 landscape --config=user.user-data="$(cat cloud-init.yaml)"

### Step 2
LANDSCAPE_IP=$(lxc list landscape --format csv -c 4 | awk '{print $1}')

### Step 3
sudo lxc config device add landscape tcp6554proxyv4 proxy listen=tcp:0.0.0.0:6554 connect=tcp:${LANDSCAPE_IP}:6554
sudo lxc config device add landscape tcp443proxyv4 proxy listen=tcp:0.0.0.0:10443 connect=tcp:${LANDSCAPE_IP}:443
sudo lxc config device add landscape tcp80proxyv4 proxy listen=tcp:0.0.0.0:10080 connect=tcp:${LANDSCAPE_IP}:80