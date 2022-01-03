#!/bin/bash
# Please run this script as root

# First, image related variables
image_path=./downloads
output_path=./outputs
image_iso="$image_path/image.img"
xz_suffix=".tomove"
tmp_image_xz="$image_iso$xz_suffix"
output_image_xz="$output_path/image.img.xz"

# Script related utilities
install_dir=./install_dir
tmp_dir=$(mktemp -d)
echo "Just created temporary mount dir $tmp_dir"

# You can start by checking out what is the format of the img
#fdisk -l $image_iso

# Now perform mount
loop_dir=$(sudo losetup --show -fP "${image_iso}")
echo "Mounting image $image_iso partitions into $loop_dir"
sudo mount ${loop_dir}p2 $tmp_dir
sudo mount ${loop_dir}p1 $tmp_dir/boot/

# do stuff to $tmp_dir which is rpi filesystem
echo "Starting actual image build"
sudo cp --remove-destination /etc/resolv.conf $tmp_dir/etc/
sudo cp -r $install_dir $tmp_dir/root/install_dir
sudo chroot $tmp_dir /bin/bash /root/install_dir/run_pi_install_script.sh

# cleanup
echo "Cleaning up temporary build directory $tmp_dir"
sudo umount $tmp_dir/boot/
sudo umount $tmp_dir
rmdir $tmp_dir

# build the xz
if [ ! -f $output_path ]; then
  mkdir -p $output_path
fi

echo "Now compressing output image to $output_image_xz"
xz --compress --threads=4 --keep --suffix=$xz_suffix $image_iso
sudo mv $tmp_image_xz $output_image_xz
