#!/bin/sh
#Script by KingKongVPN

wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -
sleep 2
echo "deb http://build.openvpn.net/debian/openvpn/release/2.4 stretch main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
#Requirement
apt update
apt upgrade -y
apt install openvpn nginx php7.0-fpm stunnel4 squid3 dropbear easy-rsa vnstat ufw build-essential fail2ban zip -y

# initializing var
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
cd /root
wget "https://github.com/xiihaiqal/script/raw/master/Files/Plugins/plugin.tgz"
wget "https://github.com/xiihaiqal/script/raw/master/Files/Menu/bashmenu.zip"

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6


# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# install webmin
cd
apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python -y
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.960_all.deb"
dpkg --install webmin_1.960_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.960_all.deb
service webmin restart

# install screenfetch
cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/xiihaiqal/autoscript/master/Files/Others/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=442/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# Install Stunnel
apt-get -y install stunnel4
wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/xiihaiqal/autoscript/master/Files/Stunnel/stunnel.pem"
wget -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/xiihaiqal/autoscript/master/Files/Stunnel/stunnel.conf"
sed -i $MYIP2 /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# install squid3
cat > /etc/squid/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10
acl ads url_regex -i "/etc/squid/ads.txt"
acl malware url_regex -i "/etc/squid/malware.txt"
http_access deny ads
http_access deny malware
acl SSL_ports port 80-8085
acl Safe_ports port 110
acl Safe_ports port 80
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
visible_hostname KingKongVPN
END
sed -i $MYIP2 /etc/squid/squid.conf;


# setting banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/johndesu090/AutoScriptDeb8/master/Files/Others/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i 's/eth0/venet0/g' config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php

# Install Fail2Ban
apt-get -y install fail2ban;
service fail2ban restart 

# install mrtg
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

#install OpenVPN
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys

# replace bits
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="PH"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="Tarlac"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="Concepcion"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="JohnFordTV"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="exodia090@gmail.com"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU="MyOrganizationalUnit"|export KEY_OU="KingKongVPN"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_NAME="EasyRSA"|export KEY_NAME="KingKongVPN"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU=KingKongVPN|' /etc/openvpn/easy-rsa/vars
#Create Diffie-Helman Pem
openssl dhparam -out /etc/openvpn/dh1024.pem 1024
# Create PKI
cd /etc/openvpn/easy-rsa
cp openssl-1.0.0.cnf openssl.cnf
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*
# create key server
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server
# setting KEY CN
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client
cd
#cp /etc/openvpn/easy-rsa/keys/{server.crt,server.key} /etc/openvpn
cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn/server.crt
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn/server.key
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/ca.crt
chmod +x /etc/openvpn/ca.crt

# Setting Server
tar -xzvf /root/plugin.tgz -C /usr/lib/openvpn/
chmod +x /usr/lib/openvpn/*
cat > /etc/openvpn/server.conf <<-END
port 1147
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh1024.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 192.168.10.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 77.88.8.7"
push "dhcp-option DNS 77.88.8.3"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
ncp-disable
cipher none
auth none

END
systemctl start openvpn@server
#Create OpenVPN Config
mkdir -p /home/vps/public_html
cat > /home/vps/public_html/client.ovpn <<-END

# Created by KingKongVPN
# https://fb.me/johndesu090
auth-user-pass
client
dev tun
proto tcp
remote $MYIP:1147@www.viber.com
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 3355
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
http-proxy $MYIP 3355
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.1
http-proxy-option CUSTOM-HEADER Host www.viber.com
http-proxy-option CUSTOM-HEADER X-Forward-Host www.viber.com
http-proxy-option CUSTOM-HEADER Connection: Keep-Alive
http-proxy-option CUSTOM-HEADER Proxy-Connection: keep-alive
END
echo '<ca>' >> /home/vps/public_html/client.ovpn
cat /etc/openvpn/ca.crt >> /home/vps/public_html/client.ovpn
echo '</ca>' >> /home/vps/public_html/client.ovpn

cat > /home/vps/public_html/OpenVPN-SSL.ovpn <<-END

# Created by KingKongVPN
auth-user-pass
client
dev tun
proto tcp
remote 127.0.0.1 1147
route $MYIP 255.255.255.255 net_gateway
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
END
echo '<ca>' >> /home/vps/public_html/OpenVPN-SSL.ovpn
cat /etc/openvpn/ca.crt >> /home/vps/public_html/OpenVPN-SSL.ovpn
echo '</ca>' >> /home/vps/public_html/OpenVPN-SSL.ovpn

cat > /home/vps/public_html/stunnel.conf <<-END

client = yes
debug = 6

[openvpn]
accept = 127.0.0.1:1147
connect = $MYIP:587
TIMEOUTclose = 0
verify = 0
sni = m.facebook.com
END

# Configure Stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -sha256 -subj '/CN=127.0.0.1/O=localhost/C=PH' -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
cat > /etc/stunnel/stunnel.conf <<-END

sslVersion = all
pid = /stunnel.pid
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
client = no

[openvpn]
accept = 587
connect = 127.0.0.1:1147
cert = /etc/stunnel/stunnel.pem

[dropbear]
accept = 444
connect = 127.0.0.1:442
cert = /etc/stunnel/stunnel.pem

END

#Setting UFW
ufw allow ssh
ufw allow 1147/tcp
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -j SNAT --to-source xxxxxxxxx
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:fail2ban-ssh - [0:0]
-A INPUT -p tcp -m multiport --dports 22 -j fail2ban-ssh
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 143  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 442  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 444  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 587  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 1147  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1147  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 3355  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 3355  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8085  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8085  -m state --state NEW -j ACCEPT 
-A INPUT -p tcp --dport 10000  -m state --state NEW -j ACCEPT
-A fail2ban-ssh -j RETURN
COMMIT
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
END
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules

# Configure Nginx
sed -i 's/\/var\/www\/html;/\/home\/vps\/public_html\/;/g' /etc/nginx/sites-enabled/default
cp /var/www/html/index.nginx-debian.html /home/vps/public_html/index.html



# Create and Configure rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e

exit 0
END
chmod +x /etc/rc.local
sed -i '$ i\echo "nameserver 77.88.8.7" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 77.88.8.3" >> /etc/resolv.conf' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local

 # Creating OVPN download site index.html
cat <<'mySiteOvpn' > /var/www/openvpn/index.html
<!DOCTYPE html>
<html lang="en">
<!-- Simple OVPN Download site by Janda Baper Group -->
<head><meta charset="utf-8" /><title>MyScriptName OVPN Config Download</title><meta name="description" content="MyScriptName Server" /><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" /><meta name="theme-color" content="#000000" /><link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css"><link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet"><link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.8.3/css/mdb.min.css" rel="stylesheet"></head><body><div class="container justify-content-center" style="margin-top:9em;margin-bottom:5em;"><div class="col-md"><div class="view"><img src="https://openvpn.net/wp-content/uploads/openvpn.jpg" class="card-img-top"><div class="mask rgba-white-slight"></div></div><div class="card"><div class="card-body"><h5 class="card-title">Config List</h5><br /><ul class="list-group"><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Globe/TM <span class="badge light-blue darken-4">Android/iOS</span><br /><small> For EZ/GS Promo with WNP,SNS,FB and IG freebies</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/GTMConfig.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Globe/TM <span class="badge light-blue darken-4">PC/Modem</span><br /><small> For EZ/GS Promo with WNP,SNS,FB and IG freebies</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/GTM-PC-Config.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For TU Promos</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/SunConfig.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Modem</span><br /><small> Without Promo/Noload</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/SunNoloadConfig.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li></ul></div></div></div></div></body></html>
mySiteOvpn
 
# Setting template's correct name,IP address and nginx Port
sed -i "s|MyScriptName|$MyScriptName|g" /var/www/openvpn/index.html
sed -i "s|NGINXPORT|$OvpnDownload_Port|g" /var/www/openvpn/index.html
sed -i "s|IP-ADDRESS|$IPADDR|g" /var/www/openvpn/index.html
# Restarting nginx service
systemctl restart nginx
 
# Creating all .ovpn config archives
cd /var/www/openvpn
zip -qq -r janda.zip *.ovpn
cd

# Install BadVPN
cd
wget -O /usr/bin/badvpn-udpgw "https://github.com/xiihaiqal/autoscript/raw/master/Files/BadVPN/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://github.com/xiihaiqal/autoscript/raw/master/Files/BadVPN/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# Configure menu
cd /usr/bin
wget https://github.com/xiihaiqal/autoscript/raw/master/Files/Menu/AutoScript_Menu.tar.gz
tar -xzvf AutoScript_Menu.tar.gz
rm AutoScript_Menu.tar.gz
sed -i -e 's/\r$//' accounts
sed -i -e 's/\r$//' bench-network
sed -i -e 's/\r$//' clearcache
sed -i -e 's/\r$//' connections
sed -i -e 's/\r$//' create
sed -i -e 's/\r$//' create_random
sed -i -e 's/\r$//' create_trial
sed -i -e 's/\r$//' delete_expired
sed -i -e 's/\r$//' diagnose
sed -i -e 's/\r$//' edit_dropbear
sed -i -e 's/\r$//' edit_openssh
sed -i -e 's/\r$//' edit_openvpn
sed -i -e 's/\r$//' edit_ports
sed -i -e 's/\r$//' edit_squid3
sed -i -e 's/\r$//' edit_stunnel4
sed -i -e 's/\r$//' locked_list
sed -i -e 's/\r$//' menu
sed -i -e 's/\r$//' options
sed -i -e 's/\r$//' ram
sed -i -e 's/\r$//' reboot_sys
sed -i -e 's/\r$//' reboot_sys_auto
sed -i -e 's/\r$//' restart_services
sed -i -e 's/\r$//' server
sed -i -e 's/\r$//' set_multilogin_autokill
sed -i -e 's/\r$//' set_multilogin_autokill_lib
sed -i -e 's/\r$//' show_ports
sed -i -e 's/\r$//' speedtest
sed -i -e 's/\r$//' user_delete
sed -i -e 's/\r$//' user_details
sed -i -e 's/\r$//' user_details_lib
sed -i -e 's/\r$//' user_extend
sed -i -e 's/\r$//' user_list
sed -i -e 's/\r$//' user_lock
sed -i -e 's/\r$//' user_unlock

# AutoReboot Tools
echo "10 0 * * * root /usr/local/bin/reboot_sys" > /etc/cron.d/reboot_sys
echo "0 1 * * * root delete_expired" > /etc/cron.d/delete_expired
echo "*0 */2 * * * root clearcache" > /etc/cron.d/clearcache

# Set Permissions
cd /usr/bin
chmod +x create
chmod +x accounts
chmod +x menu
chmod +x create
chmod +x create_random
chmod +x create_trial
chmod +x user_list
chmod +x user_details
chmod +x user_details_lib
chmod +x user_extend
chmod +x user_delete
chmod +x user_lock
chmod +x user_unlock
chmod +x connections
chmod +x delete_expired
chmod +x locked_list
chmod +x options
chmod +x set_multilogin_autokill
chmod +x set_multilogin_autokill_lib
chmod +x restart_services
chmod +x edit_ports
chmod +x show_ports
chmod +x edit_openssh
chmod +x edit_dropbear
chmod +x edit_stunnel4
chmod +x edit_openvpn
chmod +x edit_squid3
chmod +x reboot_sys
chmod +x reboot_sys_auto
chmod +x clearcache
chmod +x server
chmod +x ram
chmod +x diagnose
chmod +x bench-network
chmod +x speedtest

# add eth0 to vnstat
vnstat -u -i eth0

# compress configs
cd /home/vps/public_html
zip configs.zip client.ovpn OpenVPN-SSL.ovpn stunnel.conf

# install libxml-parser
apt-get install -y libxml-parser-perl

# finalizing
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php7.0-fpm start
service vnstat restart
service openvpn restart
service dropbear restart
service fail2ban restart
/etc/init.d/squid restart

# grep ports 
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}')"
nginxport="$(netstat -nlpt | grep -i nginx| grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

# Info
clear
echo -e ""
echo -e "\e[94m[][][]======================================[][][]"
echo -e "\e[0m                                                   "
echo -e "\e[94m           AutoScriptVPS by  KingKongVPN           "
echo -e "\e[94m                                                  "
echo -e "\e[94m                    Services                      "
echo -e "\e[94m                                                  "
echo -e "\e[94m    OpenSSH        :   "$opensshport
echo -e "\e[94m    Dropbear       :   "$dropbearport
echo -e "\e[94m    SSL            :   "$stunnel4port
echo -e "\e[94m    OpenVPN        :   "$openvpnport
echo -e "\e[94m    Port Squid     :   "$squidport
echo -e "\e[94m    Nginx          :   "$nginxport
echo -e "\e[94m                                                  "
echo -e "\e[94m              Other Features Included             "
echo -e "\e[94m    Commands       :   menu | accounts | options | server"
echo -e "\e[94m    Timezone       :   Asia/Kuala_Lumpur  (GMT +8)       "
echo -e "\e[94m    Webmin         :   http://$MYIP:10000/        "
echo -e "\e[94m    Anti-Torrent   :   [ON]                      "
echo -e "\e[94m    Cron Scheduler :   [ON]                       "
echo -e "\e[94m    Fail2Ban       :   [ON]                       "
echo -e "\e[94m    DDOS Deflate   :   [ON]                       "
echo -e "\e[94m    LibXML Parser  :   {ON]                       "
echo -e "\e[0m                                                   "
echo -e "\e[94m[][][]======================================[][][]\e[0m"
echo -e "\e[0m                                                   "
read -n1 -r -p "          Press Any Key To Show Continue      "
sleep 5
menu
cd
