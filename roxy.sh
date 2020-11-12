#!/bin/sh
# Created by https://www.hostingtermurah.net
# Modified by 0123456
 
#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi
# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";
 
# go to root
cd
 
# install squid3
apt-get -y install squid
cat > /etc/squid/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10
acl SSL_ports port 80-8085
acl Safe_ports port 88
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 444
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
acl SSH dst 103.103.0.118-103.103.0.118/32
acl SSH dst 128.199.157.230-128.199.157.230/255.255.255.255
acl SSH dst 178.128.18.93-178.128.18.93/255.255.255.255
acl SSH dst 178.128.61.6-178.128.61.6/255.255.255.255
acl SSH dst 159.65.13.145-159.65.13.145/255.255.255.255
acl SSH dst 128.199.111.9-128.199.111.9/255.255.255.255
acl SSH dst 159.65.140.10-159.65.140.10/255.255.255.255
acl SSH dst 178.128.219.61-178.128.219.61/255.255.255.255
acl SSH dst 128.199.198.111-128.199.198.111/255.255.255.255
acl SSH dst 115.164.5.48-115.164.5.48/255.255.255.255
acl SSH dst 115.164.14.11-115.164.14.11/255.255.255.255
acl SSH dst 121.123.228.74-121.123.228.74/255.255.255.255
acl SSH dst 13.250.162.203-13.250.162.203/255.255.255.255
acl all src 0.0.0.0/0
http_access allow all
http_access allow SSH
http_access allow localnet
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8085
http_port 3355
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname BADBOX
END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart
 
wget https://raw.githubusercontent.com/TongGakod/sultan/main/googlecloud && bash googlecloud && rm googlecloud
 
