#!/bin/bash
#
# Checkout https://opensource.com/article/20/5/disk-image-raspberry-pi for chroot aspects
#

# Now update and install packages
apt-get update && apt-get upgrade --yes
apt-get install --yes\
  net-tools\
  build-essential


#### TIG stack
# from https://nwmichl.net/2020/07/14/telegraf-influxdb-grafana-on-raspberrypi-from-scratch/
curl -sL https://packages.grafana.com/gpg.key | sudo apt-key add -
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian buster stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
apt-get update

sudo apt-get install -y grafana influxdb telegraf

sudo systemctl enable influxdb grafana-server telegraf
sudo systemctl start influxdb grafana-server telegraf

# config files for telegraf: influxdb
cp ./telegraf.conf /etc/telegraf/telegraf.conf
systemctl reload telegraf.service

# config files for telegraf: raspberry Pi dashboard
usermod -a -G video telegraf
cp ./raspberrypi.conf /etc/telegraf/telegraf.d/raspberrypi.conf
systemctl reload telegraf.service

# Grafana
# Open the following URL in your webbrowser: http://IP_RASPBERRYPI:3000 to reach the login screen.
# The default credentials admin / admin must be changed at first login.
# From the Grafana frontend. To add the first dashboard, mouse over the + just below the Grafana Search at the main page and choose Import. Enter the ID 10578 and Load.
