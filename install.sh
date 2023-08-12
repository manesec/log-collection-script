#! /bin/bash

apt update 
apt install -y jq net-tools curl crontab

cp -r settings /etc/log-collection
cp -r . /usr/local/log-collection

# cron setup
cp cron/log_collect/* /etc/cron.d/

systemctl restart cron
