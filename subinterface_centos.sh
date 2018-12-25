#!/bin/sh
# IP PORT PAIR Linux

ip_1=$1
netmask_1=$2
gateway_1=$3

ip_2=$4
netmask_2=$5
gateway_2=$6


cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
BOOTPROTO=none
IPADDR=$ip_1
NETMASK=$netmask_1
GATEWAY=$gateway_1
ONBOOT=yes
EOF

cat > /etc/sysconfig/network-scripts/ifcfg-eth0:0 <<EOF
DEVICE=eth0:0
BOOTPROTO=none
IPADDR=$ip_2
NETMASK=$netmask_2
GATEWAY=$gateway_2
ONBOOT=yes
EOF

ifdown eth0
ifup eth0
ifup eth0:0
