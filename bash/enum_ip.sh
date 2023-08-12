#! /bin/bash

# Get Dev name
dev=`cat /etc/log-collection/device_name`

# Get IPV4 public
echo Getting the public ipv4 ...
ipv4=`curl -s "https://api.ipify.org?format=json" | jq ".ip"`
echo $ipv4

# Get IPV6 public
echo Getting the public ipv6 ...
ipv6=`curl -s "https://ipv6.jsonip.com/" | jq ".ip"`
echo $ipv6

# Get Private IP
echo Getting Local Interface ...
iface=`ip -json address list`
echo $iface

# put data
echo ============================ DATA ===========================
data='{"dev":"'$dev'","time":"'`date '+%Y-%m-%d %H:%M:%S'`'","public_v4":'$ipv4', "public_v6":'$ipv6', "iface":'$iface'}'
b64data=`echo "$data" | tr -d '\n' | base64 -w 0`

echo $data

echo ============================ PRE ===========================

post_data='{"type":"onecloud_dev_ipaddr","data":"'$b64data'"}'
echo $post_data
echo ============================ POST ===========================
curl $(cat /etc/log-collection/post_url) -X PUT -H "Content-Type: application/json" -d $post_data


echo ============================ END ===========================
