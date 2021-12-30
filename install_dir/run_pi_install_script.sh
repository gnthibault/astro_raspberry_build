#!/bin/bash
#
# Checkout https://opensource.com/article/20/5/disk-image-raspberry-pi for chroot aspects
#

# Now update and install packages
apt-get update
apt-get install --yes\
  net-tools\
  build-essential
