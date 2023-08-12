#! /bin/bash
read -p "Enter API Server (with https): " apiserver
read -p "Enter Device name: " device


apt update 
apt install -y jq net-tools curl cron

mkdir -p /etc/log-collection/
cp -r settings/* /etc/log-collection
cp -r . /usr/local/log-collection

echo $apiserver > /etc/log-collection/post_url
echo $device > /etc/log-collection/device_name

# cron setup
cp cron/* /etc/cron.d/

systemctl restart cron
