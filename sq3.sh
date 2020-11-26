#!/bin/bash
if [ ! "$BASH" ]
then
echo "Este script foi feito para funcionar com o bash
Reiniciando o Script usando BASH em 3 segundos..."
sleep 3
bash $0 $@
exit $?
fi

menu="\033[41;1;37m"
corPadrao="\033[0m"
preto="\033[0;30m"
vermelho="\033[0;31m"
verde="\033[0;32m"
marrom="\033[0;33m"
azul="\033[0;34m"
purple="\033[0;35m"
cyan="\033[0;36m"
cinzaClaro="\033[0;37m"
pretoCinza="\033[1;30m"
vermelhoClaro="\033[1;31m"
verdeClaro="\033[1;32m"
amarelo="\033[1;33m"
azulClaro="\033[1;34m"
purpleClaro="\033[1;35m"
cyanClaro="\033[1;36m"
branco="\033[1;37m"
fim="\033[0m"
##
eth=$(ifconfig | grep -v inet6 | grep -v lo | grep -v 127.0.0.1 | grep "encap:Ethernet" | awk '{print $1}')
##
#identificacao automatica do ip
AIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$AIP" = "" ]]; then
 AIP=$(wget -qO- ipv4.icanhazip.com)
fi
##VERIFICACAO DAS PORTAS##
if [ -e /etc/default/dropbear ]; then
variaveldaport=$(cat /etc/default/dropbear |egrep -o "80" |wc -l)
 if [ "$variaveldaport" = "0" ]; then
spt="80"
else
echo $((($RANDOM %20) + 81)) > /tmp/spt
spt=$(cat /tmp/spt)
rm -rf /tmp/spt
 fi
variaveldaport2=$(cat /etc/default/dropbear |egrep -o "8080" |wc -l)
 if [ "$variaveldaport2" = "0" ]; then
spt2="8080"
else
echo $((($RANDOM %20) + 8081)) > /tmp/spt
spt2=$(cat /tmp/spt)
rm -rf /tmp/spt
 fi
variaveldaport3=$(cat /etc/default/dropbear |egrep -o "8799" |wc -l)
 if [ "$variaveldaport3" = "0" ]; then
spt3="8799"
else
echo $((($RANDOM %20) + 8800)) > /tmp/spt
spt3=$(cat /tmp/spt)
rm -rf /tmp/spt
 fi
variaveldaport4=$(cat /etc/default/dropbear |egrep -o "3128" |wc -l)
 if [ "$variaveldaport4" = "0" ]; then
spt4="3128"
else
echo $((($RANDOM %20) + 3129)) > /tmp/spt
spt4=$(cat /tmp/spt)
rm -rf /tmp/spt
 fi
else
spt="80"
spt2="8080"
spt3="8799"
spt4="3128"
fi

_portas="/tmp/$RANDOM"
_portas2="/tmp/$RANDOM"
echo "22, 143" > $_portas
echo "$spt" > $_portas2
echo "$spt2" >> $_portas2
echo "$spt3" >> $_portas2
echo "$spt4" >> $_portas2

clear
echo -e "$cyanClaro
INSTALADOR DO PROXY SQUID
$fim"
read -p "ENTER PARA PROSSEGUIR"
read -p "Digite seu IP: " -e -i $AIP ip
echo -e "$cyanClaro
Instalando SQUID3...$fim"
clear
apt-get update -y 1>/dev/null 2>/dev/null
apt-get upgrade -y 1>/dev/null 2>/dev/null
apt-get install squid3 -y 1>/dev/null 2>/dev/null
echo -e "$azulClaro
INICIANDO INSTALAÇÃO...$fim"
sleep 3s
echo -e "\033[0m"
sleep 1s

cp /etc/ssh/sshd_config /etc/ssh/sshd_back
cat /etc/ssh/sshd_config | grep -v "Port 143" > /etc/ssh/a && mv -f /etc/ssh/a /etc/ssh/sshd_config

if [[ -e /etc/squid/squid.conf ]]; then
opt="2"
sleep 2s
else
 if [[ -e /etc/squid3/squid.conf ]]; then
opt="1"
sleep 2s
else
echo -e "\033[1;36mQUAL SISTEMA ESTA USANDO?
[1] DEBIAN
[2] UBUNTO"
read -p "opção: " opt
  fi
fi

sleep 2s
###PAYLOADS###
touch /etc/payloads
echo -e ".bookclaro.com.br/
.ws.stream.qqmusic.qq.com/
.res.music.wechat.com/
.claro.com.co/
.m-gamelive.iqiyi.com/
.images.tonton.com.my/
.radio.astroradio.com.my/
.whatsapp-cdn-shv-01-any2.fbcdn.net/
.claro.com.sv/
.claro.cr/
.beta.digi.com.my/
.claroideas.com/
.imgcache.joox.com/
.service.radio.era.fm/
.dengar.era.je/
.clarosomdechamada.com.br/
.dns.joox.com/
.facebook.net/
.facebook.com/
.netclaro.com.br/
.era.fm/
.imagecache.wechat.com/
.speedtest.net/
.m.wechat.com/
.timanamaria.com.br/
.d299zc656ob0kk.cloudfront.net/
.rdio.com/
.smusic.app.wechat.com/
.vivo.ddivulga.com/
portalrecarga.vivo.com.br/recarga/home" > /etc/payloads
###FIMPAYLOADS###

##SYS###DEBIAN
if [ $opt -eq 1 ]; then
echo "#ConfiguracaoSquiD
acl url1 url_regex -i '"/etc/payloads"'
acl url2 dstdomain -i 127.0.0.1
acl url3 dstdomain -i localhost
acl url4 dstdomain -i $ip
always_direct allow all

http_access allow url1
http_access allow url2
http_access allow url3
http_access allow url4
http_access deny all
header_access From deny all
header_access Via deny all
header_access Server deny all

#portas
http_port $spt
http_port $spt2
http_port $spt3
http_port $spt4

visible_hostname r3v1v3r.pr0xy

forwarded_for off
pipeline_prefetch on
" > /etc/squid3/squid.conf
echo -e "$azulClaro
CONFIGURANDO...$fim"
echo -e "$cyanClaro REINICIANDO SERVIÇOS...$fim"
squid3 -k reconfigure 1>/dev/null 2>/dev/null
service ssh restart 1>/dev/null 2>/dev/null
service squid3 restart 1>/dev/null 2>/dev/null
sleep 1s
fi

if [ $opt -eq 2 ]; then
echo "#ConfiguracaoSquiD
acl url1 url_regex -i '"/etc/payloads"'
acl url2 dstdomain -i 127.0.0.1
acl url3 dstdomain -i localhost
acl url4 dstdomain -i $ip
always_direct allow all

http_access allow url1
http_access allow url2
http_access allow url3
http_access allow url4
acl all src 0.0.0.0/0
http_access allow all
http_access deny all
header_access From deny all
header_access Via deny all
header_access Server deny all

#portas
http_port $spt
http_port $spt2
http_port $spt3
http_port $spt4

visible_hostname r3v1v3r.pr0xy

forwarded_for off
pipeline_prefetch on
" > /etc/squid/squid.conf
sleep 1s
echo -e "$azulClaro
CONFIGURANDO...$fim"
echo -e "$cyanClaro REINICIANDO SERVIÇOS...$fim"
squid -k reconfigure 1>/dev/null 2>/dev/null
service ssh restart 1>/dev/null 2>/dev/null
service squid restart 1>/dev/null 2>/dev/null
sleep 1s
fi
echo -e "\033[1;36m
OPEN SSH RODANDO NAS PORTAS:"
cat $_portas
rm $_portas
echo -e "\033[1;36m
PROXY SQUID RODANDO NAS PORTAS"
cat $_portas2
rm $_portas2
echo -e "$fim"
sleep 1s
if [ "$eth" != "" ]; then
echo -e "\033[1;36mAplicar sistema para melhorar pacotes ssh? Pode ocorrer erros no ssh por conta dessa opção!
[s/n]\033[1;32m"
read -p ": " ssh
if [ "$ssh" = "s" ]; then
echo -e "$verde Correção de problemas de pacotes no SSH...$fim"
apt-get install ethtool -y 1>/dev/null 2>/dev/null
interface="$eth"
 if [ "$interface" = "" ]
then
interface=eth0
 fi
ethtool -G $interface rx 999999999 tx 999999999 1>/dev/null 2>/dev/null
 fi
fi
