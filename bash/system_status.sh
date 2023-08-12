#! /bin/bash

# Get Dev name
dev=`cat /etc/log-collection/device_name`

# Get W command
thew=`w -h  | sed 's/ \+/ /g' | jq -R 'split(" ")|{ user:.[0],TTY:.[1], FROM:.[2], LOGIN:.[3], IDLE:.[4], JCPU:.[5], PCPU:.[6], WHAT:.[7] }' | jq -s .`

# Get Up time
uptime=`uptime -p`

# Get memory
total=`awk '/^Mem/ {printf($2);}' <(free -m)`
used=`awk '/^Mem/ {printf($3);}' <(free -m)`
free=`awk '/^Mem/ {printf($4);}' <(free -m)`
pers=`awk '/^Mem/ {printf("%u%%", 100*$3/$2);}' <(free -m)`

# Get CPUS
cpu_per=`awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%"; }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)`

# Get TCP Status
tcp_status=`netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' | jq -R 'split(" ")|{ tcp_type:.[0], number:.[1] }' | jq -s .`

# Get Process
top10=`ps axho comm --sort -rss | head -10 | jq -Rn '{proc: [inputs]}'`

# Iface TX RX
txrx=`netstat -i | tail +3 | sed 's/ \+/ /g' | jq -R 'split(" ")|{ iface:.[0],MTU:.[1], RX_OK:.[2], RX_ERR:.[3], RX_DRP:.[4], RX_OVR:.[5], TX_OK:.[6], TX_ERR:.[7], TX_DRP:.[8],TX_OVR:.[9], Flg:.[10] }' | jq -s .`

# put data
echo ============================ DATA ===========================
data='{"dev":"'$dev'","time":"'`date '+%Y-%m-%d %H:%M:%S'`'","up_time":"'$uptime'","mem_used":'$used',"mem_free":'$free',"mem_total":'$total',"mem_pers":"'$pers'","cpu":"'$cpu_per'", "tcp_status": '$tcp_status',"w":'$thew', "top10": '$top10', "txrx": '$txrx'}'

b64data=`echo "$data" | tr -d '\n' | base64 -w 0`

echo $data

echo ============================ PRE ===========================

post_data='{"type":"onecloud_dev_system_status","data":"'$b64data'"}'
echo $post_data
echo ============================ POST ===========================
curl $(cat /etc/log-collection/post_url) -X PUT -H "Content-Type: application/json" -d $post_data


echo ============================ END ===========================
