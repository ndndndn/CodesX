#!/bin/bash
apt-get update -y
apt-get upgrade -y 
apt-get install git wget squid3 -y
IP=$(wget -4qO- "http://whatismyip.akamai.com/")
echo 'SQUID UBUNTU'
rm -rf /etc/squid/squid.conf
touch /etc/squid/squid.conf
echo 'acl ip dstdomain '$IP > /etc/squid/squid.conf
echo 'acl payload dstdomain -i "/etc/payloads"
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl netflix dstdomain .netflix.
acl redelocal src 192.168.0.1-192.168.0.254
acl vpn src 10.8.0.1-10.8.0.254
acl videoprime dstdomain .videoprime.
acl ip4 dstdomain 127.0.0.2
acl oi dstdomain 200.222.108.241

http_access allow ip
http_access allow payload
http_access allow local
http_access allow iplocal
http_access allow redelocal
http_access allow vpn
http_access allow ip4
http_access allow oi
http_access allow netflix
http_access allow videoprime

#http_port 80
http_port 8080
http_port 8799
http_port 3128

visible_hostname RNEOXBRASIL

http_access deny all

via off
forwarded_for off' >> /etc/squid/squid.conf

echo 'SQUID DEBIAN'
rm -rf /etc/squid3/squid.conf
touch /etc/squid3/squid.conf
echo 'acl ip dstdomain '$IP > /etc/squid3/squid.conf
echo 'acl payload dstdomain -i "/etc/payloads"
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl netflix dstdomain .netflix.
acl redelocal src 192.168.0.1-192.168.0.254
acl vpn src 10.8.0.1-10.8.0.254
acl videoprime dstdomain .videoprime.
acl ip4 dstdomain 127.0.0.2
acl oi dstdomain 200.222.108.241

http_access allow ip
http_access allow payload
http_access allow local
http_access allow iplocal
http_access allow redelocal
http_access allow vpn
http_access allow ip4
http_access allow oi
http_access allow netflix
http_access allow videoprime

#http_port 80
http_port 8080
http_port 8799
http_port 3128

visible_hostname RNEOXBRASIL

http_access deny all

via off
forwarded_for off' >> /etc/squid3/squid.conf

echo 'Port 22
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
PermitTunnel yes
Compression yes
AllowTcpForwarding yes
#UseDNS yes
GatewayPorts yes' > /etc/ssh/sshd_config
service squid* restart
service ssh restart
rm squidconf
