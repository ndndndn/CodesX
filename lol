#INSTALL LINUX DEBIAN  WEBMIN APACHE PHP 7.1 MYSQL-SERVER PHPMYADMIN NMAP  HEXPARROT MINECRAFT MINEOS
#-----------------------------------------------------------------------------------------------------------------
#Original Distro MInecraft file Carlos Coelho 2017 - Zept3P -
#-----------------------------------------------------------------------------------------------------------------

#FIRST DEBIAN-WEB
#----------------------------------------

#Install debian netinstall

#addres to download ------>
#http://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-8.7.1-i386-netinst.iso
#http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-8.7.1-amd64-netinst.iso
apt-get update && apt-get -y upgrade &&  apt-get -y dist-upgrade



echo THIRDY PHP MYSQL APACHE NMAP SAMBA
#----------------------------------------------------------------------


apt-get install sudo -y
visudo
# users
sudo adduser pedro
sudo adduser andre
sudo usermod -aG sudo pedro
sudo usermod -aG sudo andre
apt-get install make -y
#nano /etc/sudoers
#SEU_USUARIO ALL=(ALL:ALL) ALL
apt-get install mysql-server


##################APACHE######################
    sudo apt install -y apache2 apache2-utils libapache2-mod-php wget
   
    sudo a2enmod auth_digest ssl reqtimeout
    #sudo ufw app list 
    
    echo "Timeout 30" >> /etc/apache2/apache2.conf
    echo "ServerSignature Off" >> /etc/apache2/apache2.conf
    echo "ServerTokens Prod" >> /etc/apache2/apache2.conf
    
    sudo mkdir -p /var/www/server 
    sudo mkdir -p /var/www/public
    
    sudo chown -R www-data:www-data
    sudo chown -R zombie:zombie /var/www/html 
    sudo chown -R zombie:zombie /var/www/server 
    sudo chown -R zombie:zombie /var/www/public 

    sudo chmod -R 755 /var/www/html
    sudo chmod -R 755 /var/www/public
    sudo chmod -R 755 /var/www/server
    
    sudo systemctl restart apache2
    sudo mkdir /etc/apache2/ssl
    sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.pem -out /etc/apache2/ssl/apache.pem
    sudo chmod 600 /etc/apache2/ssl/apache.pem

    sudo a2ensite default-ssl
    sudo systemctl restart apache2
###############PHP############################
    sudo apt install php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json 
    php7.0-gd php7.0-mcrypt  php7.0-fpm php7.0-intl php-xdebug php7.0-sqlite3 php7.0-gmp php7.0-mbstring
    php7.0-xml php7.0-zip
    sudo systemctl restart apache2 
    sudo apt-get -y install php7.0-opcache php-apcu
    sudo systemctl restart apache2 
    sudo a2enmod ssl 
    sudo systemctl restart apache2
    sudo a2ensite default-ssl
    sudo systemctl restart apache2
  
#################################################
apt-get install phpmyadmin
mysql_secure_installation
apt-get install nmap -y
apt-get install samba -y
apt-get install ntfs-3g -y
#drivers impressora
apt-get install hplip -y
#  monitor lan
apt-get install iptraf-ng -y 
# case fault ifconfig
apt-get install net-tools -y
#  recover images
apt-get install testdisk  -y 
#dns-utils
apt-get install dnsutils
# monitor your Server ---  Start $glances
apt-get install glances -y 
# git
apt-get install git bc -y
# non free drivers
cp /etc/apt/source.list /etc/apt/source.list.old
rm /etc/apt/source.list
cd /etc/apt/
cd
wget https://raw.githubusercontent.com/coelhocarlos/DebianScripts/master/sources.list
apt-get update
apt-get install firmware-linux-nonfree
cd 



#mount
#mkdir /media/hd160
mkdir /media/hd2000
#mount -t ntfs-3g /dev/sdb1 /media/hd160
mount -t ntfs-3g /dev/sdb1 /media/hd2000
#cp /etc/fstab /etc/fstab.old
#rm /etc/fstab
#cd /etc/
#wget https://raw.githubusercontent.com/coelhocarlos/DebianScripts/master/fstab
cd
#samba config
cp /etc/samba/smb.conf /etc/samba/smb.conf.old
rm /etc/samba/smb.conf
cd /etc/samba/
wget https://raw.githubusercontent.com/coelhocarlos/DebianScripts/master/smb.conf
service smbd restart
cd
cp /etc/motd /etc/motd.old
rm /etc/motd
cd /etc/
wget https://raw.githubusercontent.com/coelhocarlos/DebianScripts/master/motd

cd 
------------------------------------------------------------------------
apt-get install genisoimage -y
apt-get install wimtools -y
apt-get install cabextract -y
ln -s /usr/bin/genisoimage /usr/bin/mkisofs

#----------------------------------------------------------------------
#http://minecraft.codeemo.com/mineoswiki/index.php?title=MineOS-node_(apt-get)
#-----------------------------------------
apt-get update
# update repositories
# change port nano /etc/webmin/miniserv.conf
apt-get install curl
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get update

# download the necessary prerequisite components for mineos
apt-get -y install nodejs supervisor git rdiff-backup screen build-essential openjdk-8-jre-headless

# download the most recent mineos web-ui files from github
mkdir -p /usr/games
cd /usr/games
git clone https://github.com/hexparrot/mineos-node.git minecraft
cd minecraft
git config core.filemode false
chmod +x service.js mineos_console.js generate-sslcert.sh webui.js
ln -s /usr/games/minecraft/mineos_console.js /usr/local/bin/mineos
cp mineos.conf /etc/mineos.conf
npm install

# distribute service related files
cp init/supervisor_conf /etc/supervisor/conf.d/mineos.conf

# generate self-signed certificate
./generate-sslcert.sh

# start the background service
supervisorctl reload
#supervisorctl start mineos
#supervisorctl stop mineos


echo START INSTALL UTORRENT
#-------------------------------
apt-get update
mkdir downloads
cd downloads
wget http://download.ap.bittorrent.com/track/beta/endpoint/utserver/os/linux-x64-debian-7-0
mv linux-x64-debian-7-0 linux-x64-debian-7-0.tar.gz
tar -zxvf linux-x64-debian-7-0.tar.gz -C /opt/
chown root:root -R /opt/utorrent-server-alpha-v3_3/
ln -s /opt/utorrent-server-alpha-v3_3/utserver /usr/bin/utserver
# apt-get install libssl1.0.0 libssl-dev original squeze
# for debian stretch
apt-get install gdebi -y
wget  http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u9_amd64.deb
wget  http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.0.0_1.0.2g-1ubuntu4.13_amd64.deb
apt install gdebi dirmngr
dpkg -i libssl1.0.0_1.0.1t-1+deb8u9_amd64.deb
dpkg -i libssl1.0.0_1.0.2g-1ubuntu4.13_amd64.deb
utserver -settingspath /opt/utorrent-server-alpha-v3_3/ &
#--------------------------
echo INIT AS SERVICE UTORRENT#
sudo sytemctl stop utorrent


echo install WEBMIN 
#-----------------------------------------

#in terminal server
#----------------------------------------------------------------------
apt-get update
wget https://prdownloads.sourceforge.net/webadmin/webmin_1.890_all.deb
dpkg --install webmin_1.890_all.deb
# on error fault -> libraries -> 
apt-get install -f -y
# on port error /etc/init.d/webmin restart
# editing /etc/webmin/miniserv.conf port 10000 to 10222
#nano /etc/webmin/miniserv.conf
/etc/init.d/webmin restart
#--------------------
sudo sytemctl start utorrent

wget https://raw.githubusercontent.com/coelhocarlos/debian9-install/master/utorrent
chmod 755 utorrent
cp utorrent /etc/init.d/
cd /etc/init.d/
update-rc.d utorrent defaults
service utorrent start
#systemctl status utorrent.service
service utorrent restart

#--------------------------
echo END INSTALL UTORRENT
#--------------------
# service utorrent stop
#---
#need remove 
#update-rc.d utorrent remove
#---

#-------------------------------------- MEDIA SERVE PLEX
wget https://downloads.plex.tv/plex-media-server/1.13.8.5395-10d48da0d/plexmediaserver_1.13.8.5395-10d48da0d_amd64.deb
dpkg -i plexmediaserver_1.13.8.5395-10d48da0d_amd64.deb

#GUACAMOLE
----------------------------------------
apt-get install guacamole
apt-get install libfreerdp-dev
apt-get install libssl-dev 
apt-get install libvorbis-dev
apt-get install libtool libtool-bin
apt-get install libjpeg-dev
-----------------------------------------


#------------------------
echo  IPTABLES RULES
#------------------------
#-----Allow Established and Related Incoming Connections
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -i enp1s0 -j ACCEPT
iptables -A OUTPUT -o enp1s0 -j ACCEPT
#---- RULES CAM
iptables -F
iptables -t nat -F
iptables -X

iptables -t nat -A PREROUTING -p tcp 192.168.0.50 --dport 34599 -j DNAT --to-destination 192.168.0.55:34599
iptables -t nat -A POSTROUTING -p tcp -d 192.168.0.50 --dport 34599 -j SNAT --to-source 192.168.0.55

#-----Allow Established Outgoing Connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#-----Internal to External
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT 
#-----Drop Invalid Packets
#iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
#----Block an IP Address
#iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
#----Block a invalid Packets
#iptables -A INPUT -s 15.15.15.51 -j DROP
#----Reject Network Ip
#iptables -A INPUT -s 15.15.15.51 -j REJECT
#----Reject Network Interfaces
#iptables -A INPUT -i eth0 -s 15.15.15.51 -j DROP
#----Allow All Incoming SSH 
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow Outgoing SSH
iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming HTTP
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming HTTPS
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming HTTP and HTTPS
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow All Incoming FTP
iptables -A INPUT -p tcp --dport 21-m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 21-m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow MySQL from Specific IP Address or Subnet
iptables -A INPUT -p tcp -s 15.15.15.0/24 --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#----Allow Email  
iptables -A INPUT -p tcp --dport 25 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 143 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow Eamail SMTP 
iptables -A INPUT -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 143 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow Eamail IMAP
iptables -A INPUT -p tcp --dport 993 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 993 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All Incoming POP3
iptables -A INPUT -p tcp --dport 110 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 110 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All Incoming POP3S
iptables -A INPUT -p tcp --dport 995 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 995 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All TEAMSPEAK3
iptables -A INPUT -p tcp --dport 10011 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 10011 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -A INPUT -p tcp -m tcp --dport 10000 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 11100 -j ACCEPT

iptables -A INPUT -p tcp --dport 30033 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 30033 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp --dport  9987 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --sport  9987 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#---Allow All MINECRAFT
iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25565 -m conntrack --ctstate ESTABLISHED -j ACCEPT
#--Allow All PXE
iptables -A INPUT -p ALL -i $INET_IFACE -s 192.168.0.0/24 -j ACCEPT
iptables -A INPUT -p ALL -i $INET_IFACE -d 192.168.0.255 -j ACCEPT
iptables -A udp_inbound -p UDP -s 0/0 --destination-port 69 -j ACCEPT
#--Allow All QUAKE
iptables -A INPUT -p udp -m udp --dport 27910:27912 -j ACCEPT
#--Allow All CSTRIKE
iptables -A INPUT -p udp -m udp --dport 27915:27917 -j ACCEPT
#----SAVE
iptables-save > /etc/iptables.up.rules
#----RESTORE
iptables-restore < /etc/iptables.up.rules
#---FLUSH
iptables -F
#---FINISH IPTABLES



#--------------------------
   echo TEAMSPEAK3 SERVER
#--------------------------
	
wget http://ftp.4players.de/pub/hosted/ts3/releases/3.3.1/teamspeak3-server_linux_amd64-3.3.1.tar.bz2
tar -jxvf teamspeak3-server_linux_amd64-3.3.1.tar.bz2
adduser --disabled-login teamspeak3
mv teamspeak3-server_linux_amd64 /usr/local/teamspeak3
chown -R teamspeak3 /usr/local/teamspeak3
ln -s /usr/local/teamspeak3/ts3server_startscript.sh /etc/init.d/teamspeak3
update-rc.d teamspeak3 defaults
service teamspeak3 start

#---------------------------
   echo END TEAMSPEAK
#--------------------------

cd
mkdir ~/.scripts
cd ~/.scripts
wget https://raw.githubusercontent.com/coelhocarlos/meganz/master/megasend.sh
wget https://raw.githubusercontent.com/coelhocarlos/sqldump/master/mysqldump.sh
wget https://raw.githubusercontent.com/coelhocarlos/DebianScripts/master/duck.sh
chmod +x megasend.sh
chmod +x mysqlmump.sh
chmod +x duck.sh
cd

#------------------------------------------------------------------
#Iecho INSTALL MEGATools
#--------------------------------------------------------------------
apt-get -y install build-essential libglib2.0-dev libssl-dev \ libcurl4-openssl-dev libgirepository1.0-dev
 
mkdir downloads 
cd downloads 
wget http://ftp.br.debian.org/debian/pool/main/m/megatools/megatools_1.9.98-1_amd64.deb
dpkg -i megatools_1.9.98-1_amd64.deb
cd 
cp ~/.megarc
nano ~/.megarc
#----------------------------------
#[Login]
#Username = 
#Password = 
#-----------------------------------

#-----------------------HOW TO USE -------------------------------------------------------------
#megareg –  Registrar-se e verificar uma conta nova mega.
#megadf –  Mostre seu espaço de armazenamento em nuvem uso / quota.
#megals –  Listar todos os arquivos remotos.
#megamkdir –  Criar diretório remoto.
#megarm –  Remover arquivo ou diretório remoto.
#megaput –  Upload de arquivos individuais.
#megaget –  Baixe arquivos individuais.
#megadl –  ficheiro para download a partir do link “público” Mega (não requer login).
#megastream –  Download Transmissão MegaStream de um arquivo (pode ser usado para ver os vídeos ou música).
#megasync –  Upload ou download de uma árvore de diretórios.

#Reboot to make sure it all works
## FINISH ALL INSTALED ##
cd
------------------------------------------------------------------------------------
# tftp PXE
apt-get install tftpd-hpa -y
#nano /etc/default/tftpd-hpa
cp /etc/default/tftpd-hpa /etc/default/tftpd-hpa.old
rm /etc/default/tftpd-hpa
cd /etc/default/
wget https://raw.githubusercontent.com/coelhocarlos/debian9-install/master/tftpd-hpa
/etc/init.d/tftpd-hpa restart
cd 
apt-get install dnsmasq -y
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.old
rm /etc/dnsmasq.conf
cd /etc/
wget https://raw.githubusercontent.com/coelhocarlos/debian9-install/master/dnsmasq.conf
/etc/init.d/dnsmasq restart
cd 
apt-get install isc-dhcp-server -y
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.old
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.old
rm /etc/dhcp/dhcpd.conf
rm /etc/default/isc-dhcp-server
cd /etc/default/
wget https://raw.githubusercontent.com/coelhocarlos/DebianScripts/master/isc-dhcp-server
cd
cd /etc/dhcp/
wget https://raw.githubusercontent.com/coelhocarlos/debian9-install/master/dhcpd.conf
cd 
service isc-dhcp-server restart

cp /etc/network/interfaces /etc/network/interfaces.old
rm /etc/network/interfaces
cd /etc/network/
wget https://raw.githubusercontent.com/coelhocarlos/debian9-install/master/interfaces
/etc/init.d/networking restart

apt-get update && apt-get -y upgrade &&  apt-get -y dist-upgrade
echo ## FINISH ALL INSTALED ##
