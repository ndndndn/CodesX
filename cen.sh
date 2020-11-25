#!/bin/bash
# Modified by WaGoVPN

#Requirement
if [ ! -e /usr/bin/curl ]; then
   yum -y update && yum -y upgrade
   yum -y install curl
fi

# initializing var
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable se linux
echo 0 > /selinux/enforce
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/sysconfig/selinux

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service sshd restart

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.d/rc.local

#Add DNS Server ipv4
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.d/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.d/rc.local

# install wget and curl
yum -y install wget curl

# remove unused
yum -y remove sendmail;
yum -y remove cyrus-sasl

# update
yum -y update

# install webserver
yum -y install httpd php php-pdo php-mysqli php-mysql php-gd php-mbstring.x86_64 php-fpm php-cli
mkdir -p /var/www/html/status
chmod -R 755 /var/www/html
sed -i 's/Listen 80/Listen 81/g' /etc/httpd/conf/httpd.conf
service httpd restart
chkconfig httpd on


# install essential package
yum -y install telnet telnet-server vixie-cron crontabs squid dos2unix mysql-server zip wondershaper rrdtool screen iftop htop nmap bc nethogs openvpn vnstat ngrep mtr git zsh mrtg unrar rsyslog rkhunter mrtg net-snmp net-snmp-utils expect nano bind-utils
yum install -y epel-release && yum install openvpn -y
yum -y groupinstall 'Development Tools'
yum -y install cmake

yum -y --enablerepo=rpmforge install axel sslh ptunnel unrar

# disable exim
service exim stop
chkconfig exim off


# install screenfetch
cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/wagovps/WagoVPN2/master/Tools/Screenfetch/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .bash_profile
echo "screenfetch" >> .bash_profile

# install openvpn
wget -O /etc/openvpn/openvpn.zip "https://github.com/wagovps/WagoVPN2/blob/master/Tools/OpenVPN/openvpn.zip?raw=true"
cd /etc/openvpn/
unzip openvpn.zip
chmod -R 755 /etc/openvpn
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/wagovps/WagoVPN2/master/Tools/OpenVPN/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.d/rc.local
MYIP=`dig +short myip.opendns.com @resolver1.opendns.com`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i $MYIP2 /etc/iptables.up.rules;
sed -i 's/venet0/eth0/g' /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
service openvpn restart
chkconfig openvpn on
cd

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://github.com/wagovps/WagoVPN2/blob/master/Tools/BadVPN/badvpn-udpgw?raw=true"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://github.com/wagovps/WagoVPN2/blob/master/Tools/BadVPN/badvpn-udpgw64?raw=true"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i '/Port 22/a Port  90' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port  22/g' /etc/ssh/sshd_config
service sshd restart
chkconfig sshd on

# install dropbear
cd
yum -y install dropbear
echo "OPTIONS=\"-p 80\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells
service dropbear restart
chkconfig dropbear on

# install fail2ban
cd
yum -y install fail2ban
service fail2ban restart
chkconfig fail2ban on

# install squid
yum -y install squid
cat > /etc/squid/squid.conf <<-END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
acl to_vpn1 dstdomain .tsholovpn.tk
acl to_vpn2 dstdomain .duckdns.org
http_access allow to_vpn1
http_access allow to_vpn2
acl all src 0.0.0.0/0
http_access allow all
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localnet
http_access allow localhost
http_access deny all
http_port 8888
http_port 8080
http_port 8000
http_port 3128
hierarchy_stoplist cgi-bin ?
coredump_dir /var/spool/squid
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname proxy.tsholovpn.tk
END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart
chkconfig squid on

# install ddos deflate
cd
yum -y install dnsutils dsniff
wget https://github.com/wagovps/WagoVPN2/blob/master/Tools/DDOS/ddos-deflate-master.zip?raw=true
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/master.zip

# Setting IPtables
cat > /etc/iptables.up.rules <<-END
*filter
:FORWARD ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -i eth0 -o ppp0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i ppp0 -o eth0 -j ACCEPT
-A OUTPUT -d 23.66.241.170 -j DROP
-A OUTPUT -d 23.66.255.37 -j DROP
-A OUTPUT -d 23.66.255.232 -j DROP
-A OUTPUT -d 23.66.240.200 -j DROP
-A OUTPUT -d 128.199.213.5 -j DROP
-A OUTPUT -d 128.199.149.194 -j DROP
-A OUTPUT -d 128.199.196.170 -j DROP
-A OUTPUT -d 103.52.146.66 -j DROP
-A OUTPUT -d 5.189.172.204 -j DROP
COMMIT
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
COMMIT
END
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.d/rc.local
iptables-restore < /etc/iptables.up.rules

# install bmon
yum -y install bmon

# download script
cd
wget https://raw.githubusercontent.com/wagovps/WagoVPN2/master/Tools/Menu/install-premiumscript.sh -O - -o /dev/null|sh

# cron
service crond start
chkconfig crond on

# set time GMT +2
ln -fs /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime

# finalizing
service httpd restart
service openvpn restart
service sshd restart
service dropbear restart
service fail2ban restart
service squid restart
service crond start
chkconfig crond on

#clearing history
history -c

# info
clear
echo " "
echo "INSTALLATION COMPLETE!"
echo " "
echo "-------------------------------==WaGoVPN==---------------------------------"
echo ""  | tee -a log-install.txt
echo "Server Included"  | tee -a log-install.txt
echo "   - Timezone    : Africa/Johannesburg (GMT +2)"  | tee -a log-install.txt
echo "   - Fail2Ban    : [ON]"  | tee -a log-install.txt
echo "   - IPtables    : [ON]"  | tee -a log-install.txt
echo "   - DDeflate    : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot : [OFF]"  | tee -a log-install.txt
echo "   - IPv6        : [OFF]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Application & Port Information"  | tee -a log-install.txt
echo "   - OpenVPN     : TCP 443 "  | tee -a log-install.txt
echo "   - OpenSSH     : 22, 143"  | tee -a log-install.txt
echo "   - Dropbear    : 109, 110, 442"  | tee -a log-install.txt
echo "   - Squid Proxy : 8000, 8080, 8888, 3128 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn      : 7300"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Server Tools"  | tee -a log-install.txt
echo "   - htop"  | tee -a log-install.txt
echo "   - iftop"  | tee -a log-install.txt
echo "   - mtr"  | tee -a log-install.txt
echo "   - nethogs"  | tee -a log-install.txt
echo "   - screenfetch"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Premium Script Information"  | tee -a log-install.txt
echo "Type wagovpn to display the command lists"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   Explanation of scripts and VPS setup" | tee -a log-install.txt
echo "   follow this link: http://bit.ly/penjelasansetup"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Important Information"  | tee -a log-install.txt
echo "   - Installation Log        : cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "------------------------- Modified by WaGoVPN -----------------------------"
echo ""
echo "-----Rebooting your IP: $MYIP -----"
sleep 
