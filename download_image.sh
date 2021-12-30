#!/bin/bash

# First, image related variables
#img_dl_url="https://downloads.raspberrypi.org/raspbian_lite_latest"
img_dl_url="https://cdimage.ubuntu.com/releases/20.04.3/release/ubuntu-20.04.3-preinstalled-server-arm64+raspi.img.xz"
img_sha="7e405f473d8a9e3254cd702edaeecd5509a85cde1e9e99e120f6c82156c6958f" 


# Script related utilities
image_path=./downloads
image_xz="$image_path/image.img.xz"
image_iso="$image_path/image.img"
 
# Consider checking latest ver/sha online, download only if newer
# https://downloads.raspberrypi.org/raspbian_lite/images/?C=M;O=D
# For now just delete any prior download zip to force downloading latest version
if [ ! -f $image_xz ]; then
  mkdir -p $image_path
  echo "Downloading image ..."
  # echo "Downloading latest Raspbian lite image"
  # curl often gave "error 18 - transfer closed with outstanding read data remaining"
  # wget -O $image_zip $img_dl_url
  wget -O $image_xz $img_dl_url
 
  if [ $? -ne 0 ]; then
    echo "Download failed" ; exit -1;
  fi
  
  if ! echo "$img_sha $image_xz" | shasum -a 256 --check -; then
    echo "Checksum failed for file $image_xz" >&2
    exit 1
  fi
fi
 
echo "Extracting image ${image_xz}"
#unzip $image_xz > $image_iso
xz --keep --decompress --threads=4 --stdout $image_xz > $image_iso
 
if [ $? -ne 0 ]; then
    echo "Uncompressing image ${image_xz} failed" ; exit -1;
fi
