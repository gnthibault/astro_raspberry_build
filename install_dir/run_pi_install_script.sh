#!/bin/bash
#
# Checkout https://opensource.com/article/20/5/disk-image-raspberry-pi for chroot aspects
#

# Now update and install packages
apt-get update && apt-get upgrade --yes
apt-get install --yes\
  build-essential\
  curl\
  net-tools

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

# config files for influxdb: enable REST API
# sample taken from https://github.com/influxdata/influxdb/blob/1.8/etc/config.sample.toml
# with some modifications in the [http] section
# Also check the doc for more info: https://docs.influxdata.com/influxdb/v1.8/query_language/manage-database/
cp ./influxdb.conf /etc/influxdb/influxdb.conf
systemctl restart influxdb.service
curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE "telegraf"'
curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE USER "telegraf" WITH PASSWORD "Telegr@f"'
curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=GRANT ALL ON "telegraf" TO "telegrafuser"'
curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE RETENTION POLICY "52Weeks" ON "telegraf" DURATION 52w REPLICATION 1'


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
