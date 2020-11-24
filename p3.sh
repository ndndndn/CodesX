apt-get -y install aptitude curl

if [ "$IP" = "" ]; then
        IP=$(curl -s ifconfig.me)
fi

aptitude -y install squid3
rm -f /etc/squid3/squid.conf

wget -P /etc/squid3/ "https://raw.githubusercontent.com/paradoxicalx/squid3/master/squid.conf"
sed -i "s/ipserver/$IP/g" /etc/squid3/squid.conf
service squid3 restart
