#!/bin/bash
#
# Original script by fornesia, rzengineer and fawzya 
# Mod By Zuan We Lose
# 
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# company name details
country=ID
state=JATENG
locality=GROBOGAN
organization=ZUANWELOSE
organizationalunit=JSTHUNTER
commonname=JSTFREENET
email=zuan@gmail.com

# configure rc.local
cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
EOF
chmod +x /etc/rc.local
systemctl daemon-reload
systemctl start rc-local

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# add dns server ipv4
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 1.1.1.1" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 1.0.0.1" >> /etc/resolv.conf' /etc/rc.local

# install wget and curl
apt-get -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# set repo
echo 'deb http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -

# update
apt-get update

# install webserver
apt-get -y install nginx

# install essential package
apt-get -y install nano iptables-persistent dnsutils screen whois ngrep unzip unrar

echo "clear" >> .bashrc
echo 'echo -e ""' >> .bashrc
echo 'echo -e "      ┈┈╭━╱▔▔▔▔╲━╮┈┈┈  " | lolcat' >> .bashrc
echo 'echo -e "      ┈┈╰╱╭▅╮╭▅╮╲╯┈┈┈          " | lolcat ' >> .bashrc
echo 'echo -e "      ╳┈┈▏╰┈▅▅┈╯▕┈┈┈┈           " | lolcat ' >> .bashrc
echo 'echo -e "      ┈┈┈╲┈╰━━╯┈╱┈┈╳┈   " | lolcat ' >> .bashrc
echo 'echo -e "      ┈┈┈╱╱▔╲╱▔╲╲┈┈┈┈     " | lolcat ' >> .bashrc
echo 'echo -e "      ┈╭━╮▔▏┊┊▕▔╭━╮┈╳ " | lolcat ' >> .bashrc
echo 'echo -e "      ┈┃┊┣▔╲┊┊╱▔┫┊┃┈┈  " | lolcat ' >> .bashrc
echo 'echo -e "      ┈╰━━━━╲╱━━━━╯┈╳   " | lolcat ' >> .bashrc
echo 'echo -e "                   JSTFREENET " | lolcat' >> .bashrc
echo 'echo -e "welcome to the server $HOSTNAME" | lolcat' >> .bashrc
echo 'echo -e "Script mod Zuan We Lose" | lolcat' >> .bashrc
echo 'echo -e "Type menu to display a list of commands" | lolcat' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/nstfreenet/debian/main/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by JSTFREENET</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/nstfreenet/debian/main/vps.conf"

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/doreimon1719/my-script/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/doreimon1719/my-script/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE   #192.168.100.0/24
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/doreimon1719/my-script/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

#konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/doreimon1719/my-script/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/
# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/nstfreenet/debian/main/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/nstfreenet/debian/main/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 456 -p 999"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
apt-get -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/nstfreenet/debian/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf;

# install webmin
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 443
connect = 127.0.0.1:143

[dropbear]
accept = 444
connect = 127.0.0.1:143

[dropbear]
accept = 445
connect = 127.0.0.1:143

[dropbear]
accept = 446
connect = 127.0.0.1:143

[openvpn]
accept = 990
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# configure stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
cd /etc/stunnel/
wget -O /etc/stunnel/ssl.conf "https://raw.githubusercontent.com/nstfreenet/debian/main/ssl.conf"
sed -i $MYIP2 /etc/stunnel/ssl.conf;
cp ssl.conf /home/vps/public_html/
cd

# colored text
apt-get -y install ruby
gem install lolcat

# install fail2ban
apt-get -y install fail2ban

# install ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://raw.githubusercontent.com/nstfreenet/debian/main/ddos-deflate-master.zip
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/ddos-deflate-master.zip

# banner /etc/bnr
wget -O /etc/banner.txt "https://raw.githubusercontent.com/nstfreenet/debian/main/banner.txt"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/banner.txt"@g' /etc/default/dropbear

# xml parser
cd
apt-get install -y libxml-parser-perl

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/nstfreenet/debian/main/menu.sh"
wget -O edit "https://raw.githubusercontent.com/nstfreenet/debian/main/edit-ports.sh"
wget -O edit-dropbear "https://raw.githubusercontent.com/nstfreenet/debian/main/edit-dropbear.sh"
wget -O edit-openssh "https://raw.githubusercontent.com/nstfreenet/debian/main/edit-openssh.sh"
wget -O edit-openvpn "https://raw.githubusercontent.com/nstfreenet/debian/main/edit-openvpn.sh"
wget -O edit-squid3 "https://raw.githubusercontent.com/nstfreenet/debian/main/edit-squid3.sh"
wget -O edit-stunnel4 "https://raw.githubusercontent.com/nstfreenet/debian/main/edit-stunnel4.sh"
wget -O show-ports "https://raw.githubusercontent.com/nstfreenet/debian/main/show-ports.sh"
wget -O usernew "https://raw.githubusercontent.com/nstfreenet/debian/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/nstfreenet/debian/main/trial.sh"
wget -O delete "https://raw.githubusercontent.com/nstfreenet/debian/main/delete.sh"
wget -O check "https://raw.githubusercontent.com/nstfreenet/debian/main/user-login.sh"
wget -O member "https://raw.githubusercontent.com/nstfreenet/debian/main/user-list.sh"
wget -O restart "https://raw.githubusercontent.com/nstfreenet/debian/main/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/nstfreenet/debian/main/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/nstfreenet/debian/main/info.sh"
wget -O about "https://raw.githubusercontent.com/nstfreenet/debian/main/about.sh"

chmod +x menu
chmod +x edit
chmod +x edit-dropbear
chmod +x edit-openssh
chmod +x edit-openvpn
chmod +x edit-squid3
chmod +x edit-stunnel4
chmod +x show-ports
chmod +x usernew
chmod +x trial
chmod +x delete
chmod +x check
chmod +x member
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/webmin restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid start
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# grep ports 
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}')"
nginxport="$(netstat -nlpt | grep -i nginx| grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

#!/bin/bash
# Script restart service dropbear, webmin, squid3, openvpn, openssh, nginx, cron, fail2ban, stunnel4
# Modified by Zuan We Lose
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/webmin restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid restart

# remove unnecessary files
apt -y autoremove
apt -y autoclean
apt -y clean

# info
clear
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22"  | tee -a log-install.txt
echo "Dropbear : 143, 456, 999"  | tee -a log-install.txt
echo "SSL      : 443,444,445,446"  | tee -a log-install.txt
echo "OpenVPNSSL : 990"  | tee -a log-install.txt
echo "Squid3   : 80, 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "SSL      : http://$MYIP:81/ssl.conf"  | tee -a log-install.txt
echo "OpenVPNSSL: http://$MYIP:81/openvpnssl.ovpn"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7200"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu (Displays a list of available commands)"  | tee -a log-install.txt
echo "edit (Edit Ports)"  | tee -a log-install.txt
echo "usernew (Creating an SSH Account)"  | tee -a log-install.txt
echo "trial (Create a Trial Account)"  | tee -a log-install.txt
echo "delete (Clearing SSH Account)"  | tee -a log-install.txt
echo "check (Check User Login)"  | tee -a log-install.txt
echo "member (Check Member SSH)"  | tee -a log-install.txt
echo "restart (Restart Service dropbear, webmin, squid3, openvpn and ssh)"  | tee -a log-install.txt
echo "reboot (Reboot VPS)"  | tee -a log-install.txt
echo "speedtest (Speedtest VPS)"  | tee -a log-install.txt
echo "info (System Information)"  | tee -a log-install.txt
echo "about (Information about auto install script)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Other features"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Original Script by Fornesia, Rzengineer & Fawzya"  | tee -a log-install.txt
echo "Modified by Zuan We Lose"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo -e "=============================" | tee -a log-install.txt
echo -e "Join us : " | tee -a log-install.txt
echo -e "https://t.me/JSTFREENET" | tee -a log-install.txt
echo -e "https://t.me/freedom_reborn" | tee -a log-install.txt
echo -e "https://t.me/xtconfig" | tee -a log-install.txt
echo -e "https://t.me/nge_gasss" | tee -a log-install.txt
echo -e "https://t.me/PXGI_GRUP" | tee -a log-install.txt
echo -e "https://t.me/configarea" | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/ho.sh
