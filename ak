#!/bin/bash

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
	exit
fi
if [[ ! -e /dev/net/tun ]]; then
	echo "TUN/TAP is not available"
	exit
fi
echo "
AUTOSCRIPT RUN
SETUP BY MKSSHVPN
WAITING...
"
clear
echo "START AUTOSCRIPT"
clear
echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Thailand /etc/localtime;
clear
echo "
ENABLE IPV4 AND IPV6
COMPLETE 1%
"
echo ipv4 >> /etc/modules
echo ipv6 >> /etc/modules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p
clear

echo "
REMOVE SPAM PACKAGE
COMPLETE 10%
"
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear
echo "
UPDATE AND UPGRADE PROCESS 
PLEASE WAIT TAKE TIME 1-5 MINUTE
"

#install menu
wget https://raw.githubusercontent.com/zero9911/a/master/script/menu
wget https://raw.githubusercontent.com/zero9911/a/master/script/user-list
wget https://raw.githubusercontent.com/zero9911/a/master/script/monssh
wget https://raw.githubusercontent.com/zero9911/a/master/script/status
mv menu /usr/local/bin/
mv user-list /usr/local/bin/
mv monssh /usr/local/bin/
mv status /usr/local/bin/
chmod +x  /usr/local/bin/menu
chmod +x  /usr/local/bin/user-list
chmod +x  /usr/local/bin/monssh
chmod +x  /usr/local/bin/status
cd

# moth
cd
wget https://raw.githubusercontent.com/zero9911/a/master/script/motd
mv ./motd /etc/motd



# ssh
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
wget -O /etc/issue.net "https://raw.githubusercontent.com/zero9911/a/master/script/banner"

# dropbear
apt-get -y install dropbear
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/zero9911/a/master/script/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cd

# squid3
apt-get -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/zero9911/a/master/script/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid/squid.conf
cd

# openvpn
mkdir -p /home/vps/public_html
apt-get -y install openvpn
cd /etc/openvpn/
wget https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/openvpn.tar;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
# etc
wget -O /home/vps/public_html/client.ovpn "https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/client.ovpn"
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn
cd;wget https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/cronjob.tar
tar xf cronjob.tar;mv uptime.php /home/vps/public_html/
mv usertol userssh uservpn /usr/bin/;mv cronvpn cronssh /etc/cron.d/
chmod +x /usr/bin/usertol;chmod +x /usr/bin/userssh;chmod +x /usr/bin/uservpn;
echo "UPDATE AND INSTALL COMPLETE COMPLETE 99% BE PATIENT"
cd

# restart service
service ssh restart
service openvpn restart
service dropbear restart
service squid restart


echo "

Install Complete.......
"
cat /dev/null > ~/.bash_history && history -c
exit
fi
