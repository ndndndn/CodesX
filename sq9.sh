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
##SISTEMA DE PORTAS SQUID3
maisporta2 () {
echo -e "\033[1;34m________________________________________\033[0m"
echo -e "\033[1;33mDIGITE QUAL PORTA DESEJA ABRIR... 
79,320,1150,3130,8000,8090...\033[0m"
read -p "PORTA: " pt
if [ "$pt" = "22" ]
then
echo -e "\033[1;31mPORTA 22 DESTINADA AO OPENSSH\033[0m"
funcao2
else
  if [ "$pt" = "80" ]
then
echo -e "\033[1;31mPORTA 80 JA VEM ABERTA\033[0m"
funcao2
echo -e "\033[1;34m________________________________________\033[0m"
else
   if [ "$pt" = "443" ]
then
echo -e "\033[1;31mPORTA 443 DESTINADA AO OPENSSH\033[0m"
funcao2
echo -e "\033[1;34m________________________________________\033[0m"
else
     if [ "$pt" = "8080" ]
then
echo -e "\033[1;31mPORTA 8080 JA VEM ABERTA\033[0m"
echo -e "\033[1;34m________________________________________\033[0m"
funcao2
else
        if [ "$pt" = "3128" ]
then
echo -e "\033[1;31mPORTA 3128 JA VEM ABERTA\033[0m"
funcao2
echo -e "\033[1;34m________________________________________\033[0m"
else
          if [[ -e /etc/squid/squid.conf ]]; then
sed -i "s/#portas/#portas\nhttp_port $pt/g" /etc/squid/squid.conf
sleep 2s
else
sed -i "s/#portas/#portas\nhttp_port $pt/g" /etc/squid3/squid.conf
sleep 2s
     fi
    fi
   fi
  fi
 fi
fi
echo -e "\033[7;31m\033[7;41m"
for prog in $(seq 13);
do
echo -n "||"
sleep 0.1s
echo -n "|"
sleep 0.1s
done
echo ""
sleep 1s
echo -e "\033[0m\033[1;31m
A Porta \033[1;33m$pt\033[1;31m Foi Adicionada ao SQUID! $fi"
echo -e "\033[1;34m________________________________________\033[0m"
echo -e ""
echo "$pt" >> /tmp/portas2
funcao2
sleep 1s
}

funcao2 () {
echo -e "\033[1;32mDESEJA ABRIR MAIS PORTAS PARA O SQUID?\033[0m"
read -p "[s/n]: " apr
if [ "$apr" = "s" ]
then
maisporta2
else
echo -e "\033[1;31mCONTINUANDO...\033[0m"
fi
sleep 1s
}
##FIM SISTEMA PORTAS SQUID3
##SISTEMA DE PORTAS OPENSSH
maisporta () {
echo -e "\033[1;34m________________________________________\033[0m"
echo -e "\033[1;33mDIGITE QUAL PORTA DESEJA ABRIR... 
20,90,440,8081,9000...\033[0m"
read -p "PORTA: " pt
if [ "$pt" = "22" ]
then
echo -e "\033[1;31mPORTA 22 JA VEM ABERTA\033[0m"
echo -e "\033[1;34m________________________________________\033[0m"
else
if [ "$pt" = "443" ]
then
echo -e "\033[1;31mPORTA 443 JA VEM ABERTA\033[0m"
echo -e "\033[1;34m________________________________________\033[0m"
else
sed -i "s/Port 22/Port 22\nPort $pt/g" /etc/ssh/sshd_config
echo -e "\033[7;31m\033[7;41m"
for prog in $(seq 13);
do
echo -n "||"
sleep 0.1s
echo -n "|"
sleep 0.1s
done
echo ""
sleep 1s
echo -e "\033[0m\033[1;31m
A Porta \033[1;33m$pt\033[1;31m Foi Adicionada ao OpenSSH! $fi"
echo -e "\033[1;34m________________________________________\033[0m"
echo -e ""
echo "$pt" >> /tmp/portas
funcao
sleep 1s
 fi
fi
}

funcao () {
echo -e "\033[1;32mDESEJA ABRIR MAIS PORTAS PARA O OPENSSH?\033[0m"
read -p "[s/n]: " apr
if [ "$apr" = "s" ]
then
maisporta
else
echo -e "\033[1;31mCONTINUANDO...\033[0m"
fi
sleep 1s
}
##FIM SISTEMA PORTAS OPENSSH
##
eth=$(ifconfig | grep -v inet6 | grep -v lo | grep -v 127.0.0.1 | grep "encap:Ethernet" | awk '{print $1}')
##
#identificacao automatica do ip
AIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$AIP" = "" ]]; then
		AIP=$(wget -4qO- "http://whatismyip.akamai.com/")
fi
echo -e "$cyanClaro
INSTALADOR DO PROXY SQUID
$fim"
read -p "ENTER PARA PROSSEGUIR"
read -p "Digite seu IP: " -e -i $AIP ip
echo -e "$cyanClaro
Instalando SQUID3...$fim"
apt-get update 1>/dev/null 2>/dev/null
apt-get upgrade -y 1>/dev/null 2>/dev/null
apt-get install squid3 -y 1>/dev/null 2>/dev/null
echo -e "$azulClaro
INICIANDO INSTALAÇAO...$fim"
sleep 3s
echo -e "\033[0m"
echo -e "\033[1;33mDESEJA CONFIGURAR O SQUID PARA UM FUNCIONAMENTO MAIS GENERICO? OU MAIS SEGURO?

\033[1;31mO FUNCIONAMENTO GENERICO PERMITE QUE VOCE ADICIONE UM DOMINIO COMO PAYLOAD E EVENTUALMENTE USE TAMBEM OS SEUS SUBDOMINIOS, INDISPENSAVEL PARA TESTES EM DOMINIOS DAS OPERADORAS, POREM SEU SQUID PODE SER USADO COMO PROXY PUBLICO COM DNS REVERSO!

O FUNCIONAMENTO SEGURO GARANTE MAIOR PROTECAO, POREM VOCE IRA TER QUE ADICIONAR O DOMINIO DO HOST DA PAYLOAD EXATAMENTE COMO USA... EX: \033[1;36mwww.host.com/sub/sub1/oarqo.php\033[1;31m PARA O CORRETO FUNCIONAMENTO.

QUAL SQUID VAI QUERER?
[1] - GENERICO
[2] - SEGURO"
read -p "opção: " squidinstall
echo -e "\033[0m"
sleep 1s
#
echo -e "\033[1;33mINSTALACAO PADRAO OU PERSONALIZADA?"
read -p "[1] - PADRAO
[2] - PERSONALIZADA
: " padr
echo -e "\033[0m"
case $padr in
1)
insta="1"
;;
2)
insta="2"
;;
*)
insta="1"
;;
esac
cp /etc/ssh/sshd_config /etc/ssh/squidbak
echo -e " " >> /etc/ssh/sshd_config
sed -i "s/Port 22/Port 22\nPort 443/g" /etc/ssh/sshd_config
echo -e "ClientAliveCountMax 0
ClientAliveInterval 180" >> /etc/ssh/sshd_config
sleep 1s
touch /tmp/portas
touch /tmp/portas2
echo -e "80\n8080\n8799\n3128" >> /tmp/portas2
echo -e "22\n443" >> /tmp/portas
##adrport
if [ "$insta" = "2" ]; then
echo -e "\033[1;31mANALISANDO OPENSSH INSTALADO...\033[0m"
sleep 3s
echo -e "\033[1;32mDESEJA ABRIR MAIS PORTAS PARA O OPENSSH?\033[1;31m PADRAO JA ABERTAS!\033[0m"
read -p "[s/n]: " sshp
 if [ "$sshp" = "s" ]
then
maisporta
else
echo -e "\033[1;31mContinuando...\033[0m"
 fi
fi
###detectSquid
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
###
case $squidinstall in
  2)
#Squid Seguro
sleep 2s
###PAYLOADS###
touch /etc/payloads
echo -e "bookclaro.com.br
clarocurtas.com.br
claroideias.com.br
claromusica.com
clarosomdechamada.com.br
portalrecarga.vivo.com.br
vivo.ddivulga.com" > /etc/payloads
###FIMPAYLOADS###

##SYS###DEBIAN
if [ $opt -eq 1 ]; then
echo "#ConfiguracaoSquiD
acl url1 dstdomain -i '/etc/payloads'
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
http_port 80
http_port 8080
http_port 8799
http_port 3128

visible_hostname PROXYSERVER

forwarded_for off
pipeline_prefetch on
" > /etc/squid3/squid.conf
##
if [ "$insta" = "2" ]; then
echo -e "\033[1;32mDESEJA ABRIR MAIS PORTAS PARA O SQUID?\033[1;31m PORTAS PADRAO JA ABERTAS!\033[0m"
read -p "[s/n]: " squi
 if [ "$squi" = "s" ]
then
maisporta2
else
echo -e "\033[1;31mCONTINUANDO...\033[0m"
 fi
fi
##
echo -e "$azulClaro
CONFIGURANDO...$fim"
echo -e "$cyanClaro REINICIANDO SERVIÇOS...$fim"
squid3 -k reconfigure 1>/dev/null 2>/dev/null
service ssh restart 1>/dev/null 2>/dev/null
service squid3 restart 1>/dev/null 2>/dev/null
sleep 1s
fi

##SYS###UBUNTU
if [ $opt -eq 2 ]; then
echo "#ConfiguracaoSquiD
acl url1 dstdomain -i '/etc/payloads'
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
http_port 80
http_port 8080
http_port 8799
http_port 3128

visible_hostname PROXYSERVER

forwarded_for off
pipeline_prefetch on
" > /etc/squid/squid.conf
##
if [ "$insta" = "2" ]; then
echo -e "\033[1;32mDESEJA ABRIR MAIS PORTAS PARA O SQUID?\033[1;31m PORTAS PADRAO JA ABERTAS!\033[0m"
read -p "[s/n]: " squi
 if [ "$squi" = "s" ]
then
maisporta2
else
echo -e "\033[1;31mCONTINUANDO...\033[0m"
 fi
fi
##
echo -e "$azulClaro
CONFIGURANDO...$fim"
echo -e "$cyanClaro REINICIANDO SERVIÇOS...$fim"
squid -k reconfigure 1>/dev/null 2>/dev/null
service ssh restart 1>/dev/null 2>/dev/null
service squid restart 1>/dev/null 2>/dev/null
sleep 1s
fi

sleep 1s
#### ethool ##### 3 parte ######
if [ "$insta" = "2" ]; then
echo -e "\033[1;36mAPLICAR SISTEMA PARA MELHORAR PACOTES SSH?
[s/n]\033[0m"
read -p ": " ssh
 if [ "$ssh" = "s" ]
then
echo -e "$verde Correção de problemas de pacotes no SSH...$fim"
apt-get install ethtool -y 1>/dev/null 2>/dev/null
read -p "Digite o nome da sua interface de rede PADRAO: $eth" interface
   if [ "$interface" = "" ]
then
interface=eth0
   fi
ethtool -G $interface rx 999999999 tx 999999999 1>/dev/null 2>/dev/null
echo -e "\033[1;36m
OPEN SSH RODANDO NAS PORTAS:"
cat /tmp/portas
rm -rf /tmp/portas
echo -e "$fim"
echo -e "\033[1;36m
PROXY SQUID RODANDO NAS PORTAS"
cat /tmp/portas2
rm -rf /tmp/portas2
echo -e "$fim"
sleep 5s
exit
 fi
fi
echo -e "\033[1;36m
OPEN SSH RODANDO NAS PORTAS:"
cat /tmp/portas
rm -rf /tmp/portas
echo -e "$fim"
echo -e "\033[1;36m
PROXY SQUID RODANDO NAS PORTAS"
cat /tmp/portas2
rm -rf /tmp/portas2
echo -e "$fim"
sleep 5s
exit
;;
  1)
### Squid Generico
sleep 2s
###PAYLOADS###
touch /etc/payloads
echo -e ".bookclaro.com.br
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
.compute-1.amazonaws.com
.portalrecarga.vivo.com.br
.vivo.ddivulga.com" > /etc/payloads
###FIMPAYLOADS###

##SYS###DEBIAN
if [ $opt -eq 1 ]; then
echo "#ConfiguracaoSquiD
acl url1 url_regex -i '/etc/payloads'
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
http_port 80
http_port 8080
http_port 8799
http_port 3128

visible_hostname PROXYSERVER

forwarded_for off
pipeline_prefetch on
" > /etc/squid3/squid.conf
##
if [ "$insta" = "2" ]; then
echo -e "\033[1;32mDESEJA ABRIR MAIS PORTAS PARA O SQUID?\033[1;31m PORTAS PADRAO JA ABERTAS!\033[0m"
read -p "[s/n]: " squi
 if [ "$squi" = "s" ]
then
maisporta2
else
echo -e "\033[1;31mCONTINUANDO...\033[0m"
 fi
fi
##
echo -e "$azulClaro
CONFIGURANDO...$fim"
echo -e "$cyanClaro REINICIANDO SERVIÇOS...$fim"
squid3 -k reconfigure 1>/dev/null 2>/dev/null
service ssh restart 1>/dev/null 2>/dev/null
service squid3 restart 1>/dev/null 2>/dev/null
sleep 1s
fi

##SYS###UBUNTU
if [ $opt -eq 2 ]; then
echo "#ConfiguracaoSquiD
acl url1 url_regex -i '/etc/payloads'
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
http_port 80
http_port 8080
http_port 8799
http_port 3128

visible_hostname PROXYSERVER

forwarded_for off
pipeline_prefetch on
" > /etc/squid/squid.conf
sleep 1s
##
if [ "$insta" = "2" ]; then
echo -e "\033[1;31mDESEJA ABRIR MAIS PORTAS PARA O SQUID?\033[1;31m PORTAS PADRAO JA ABERTAS!\033[0m"
read -p "[s/n]: " squi
 if [ "$squi" = "s" ]
then
maisporta2
else
echo -e "\033[1;31mCONTINUANDO...\033[0m"
 fi
fi
##
echo -e "$azulClaro
CONFIGURANDO...$fim"
echo -e "$cyanClaro REINICIANDO SERVIÇOS...$fim"
squid -k reconfigure 1>/dev/null 2>/dev/null
service ssh restart 1>/dev/null 2>/dev/null
service squid restart 1>/dev/null 2>/dev/null
sleep 1s
fi
sleep 1s
#### ethool ##### 3 parte ######
if [ "$insta" = "2" ]; then
echo -e "\033[1;36mAPLICAR SISTEMA PARA MELHORAR PACOTES SSH?
[s/n]\033[0m"
read -p ": " ssh
 if [ "$ssh" = "s" ]
then
echo -e "$verde Correção de problemas de pacotes no SSH...$fim"
apt-get install ethtool -y 1>/dev/null 2>/dev/null
read -p "Digite o nome da sua interface de rede PADRAO: $eth" interface
   if [ "$interface" = "" ]
then
interface=eth0
   fi
ethtool -G $interface rx 999999999 tx 999999999 1>/dev/null 2>/dev/null
echo -e "\033[1;36m
OPEN SSH RODANDO NAS PORTAS:"
cat /tmp/portas
rm -rf /tmp/portas
echo -e "$fim"
echo -e "\033[1;36m
PROXY SQUID RODANDO NAS PORTAS"
cat /tmp/portas2
rm -rf /tmp/portas2
echo -e "$fim"
sleep 5s
exit
 fi
fi
echo -e "\033[1;36m
OPEN SSH RODANDO NAS PORTAS:"
cat /tmp/portas
rm -rf /tmp/portas
echo -e "$fim"
echo -e "\033[1;36m
PROXY SQUID RODANDO NAS PORTAS"
cat /tmp/portas2
rm -rf /tmp/portas2
echo -e "$fim"
sleep 5s
exit
;;
  *)
rm -rf /tmp/portas
rm -rf /tmp/portas2
exit
;;
esac
exit
