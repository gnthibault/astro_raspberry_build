#!/bin/bash

apt-get install qemu-system-arm

# Enable non-native arch chroot with DNF, adding new binary format information
# Output suppressed for brevity
apt-get install qemu-user-static
systemctl restart systemd-binfmt.service

# from https://stackoverflow.com/questions/19383887/how-to-use-sudo-in-build-script-for-gitlab-ci
#You can grant sudo permissions to the gitlab-runner user as this is who is executing the build script.
#$ sudo usermod -a -G sudo gitlab-runner
#You now have to remove the password restriction for sudo for the gitlab-runner user.
#Start the sudo editor with
#$ sudo visudo
#Now add the following to the bottom of the file
#gitlab-runner ALL=(ALL) NOPASSWD: ALL
# You may also prefer specifying which command the sudo user can use witout pwd
# gitlab-runner ALL=(ALL) NOPASSWD: /usr/bin/npm
