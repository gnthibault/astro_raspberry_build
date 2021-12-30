#!/bin/bash

apt-get install qemu-system-arm

# Enable non-native arch chroot with DNF, adding new binary format information
# Output suppressed for brevity
apt-get install qemu-user-static
systemctl restart systemd-binfmt.service

