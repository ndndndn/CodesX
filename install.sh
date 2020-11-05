#!/bin/bash
##
## ArtificialVPN Server Configuration
## by M4rshall
##
## Copyright (c) ArtificialVPN 2018. All Rights Reserved
##



## Check if VPS have root access
if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit
fi

## Check if TUN Device is available
if [[ ! -e /dev/net/tun ]]; then
	echo "The TUN device is not available
You need to enable TUN before running this script"
	exit
fi

## Check if VPS have Debian OS
if [[ -e /etc/debian_version ]]; then
	OS=debian
	GROUPNAME=nogroup
	RCLOCAL='/etc/rc.local'
else
	echo "Looks like you aren't running this installer on Debian, Ubuntu or CentOS"
	exit
fi

## GET REAL IP
if [[ "$PUBLICIP" != "" ]]; then
	IP=$PUBLICIP
fi

## Updating System and Installing OpenVPN and other Application
apt-get update
apt-get install openvpn ufw squid3 p7zip-full apache2 -y

## Packet Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i '/net.ipv4.ip_forward=1/s/^#//g' /etc/sysctl.conf
ufw allow ssh
ufw allow 443/tcp
ufw allow 8080/tcp
ufw allow 8989/tcp
ufw allow 8000/tcp
ufw allow 3128/tcp
ufw allow 8888/tcp
sed -i 's/\(DEFAULT_FORWARD_POLICY=\).*/\1"ACCEPT"/' /etc/default/ufw
wget -O /etc/ufw/before.rules https://raw.githubusercontent.com/m4rshall-dev/ovpn-files/master/before.rules
echo y | ufw enable

## Downloading Keys and Config for OpenVPN Server
cd ~/
rm *
wget https://www.dropbox.com/s/p94a7aedlpt71ko/keys.zip?dl=0
mv keys.zip?dl=0 keys.zip
7za x -P20m4rshall18 keys.zip
rm keys.zip
mkdir /etc/openvpn/keys
wget -O /etc/openvpn/server.conf https://raw.githubusercontent.com/m4rshall-dev/ovpn-files/master/server.conf
mv * /etc/openvpn/keys/

## Download Script
cd /etc/openvpn
mkdir script
touch /etc/openvpn/script/login.sh
wget -O /etc/openvpn/script/login.sh https://raw.githubusercontent.com/m4rshall-dev/ovpn-files/master/login.sh
touch /var/www/html/m4rshall.txt
chmod 755 /var/www/html/m4rshall.txt
chmod 755 /etc/openvpn/*
chmod 755 /etc/openvpn/script/login.sh

## Configure Squid Proxy
wget -O /etc/squid3/squid.conf https://raw.githubusercontent.com/ndndndn/GG/main/squid.conf
IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
sed -i "s/ipmokasito/$IP/g" /etc/squid3/squid.conf

cd ~
wget https://raw.githubusercontent.com/m4rshall-dev/ovpn-files/master/test.sh
chmod 755 ~/test.sh

crontab -l > mycron
echo "* * * * * ~/test.sh" >> mycron
crontab mycron
rm mycron

wget https://raw.githubusercontent.com/m4rshall-dev/ovpn-files/master/install2.sh
chmod +x install2.sh | bash install2.sh

## Start OpenVPN Service
service openvpn restart
service squid3 restart
echo ""
echo "Status:"
service openvpn status
service squid3 status
