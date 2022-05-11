#!/bin/bash
hostname="h0stname"


while true
do

node_blocks=`curl -s 127.0.0.1:9101/metrics  | grep aptos_state_sync_version |grep type|grep committed|cut -f2 -d' '`
network_blocks=`curl -s 127.0.0.1:9101/metrics  | grep aptos_state_sync_version |grep type|grep committed|cut -f2 -d' '`

echo "block,host=$hostname,type=node count=$node_blocks
block,host=$hostname,type=network count=$network_blocks" |influx write --bucket data1
sleep 1800
done
