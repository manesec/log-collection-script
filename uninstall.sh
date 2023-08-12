#! /bin/bash

rm -rf /etc/log-collection
rm -rf /usr/local/log-collection

# cron setup
rm -r/etc/cron.d/log_collect
rm -r/etc/cron.d/log_collect_update

systemctl restart cron
