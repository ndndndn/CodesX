#!/bin/sh
# Created by https://www.hostingtermurah.net
# Modified by 0123456

#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi
# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# install squid3
apt-get -y install squid
cat > /etc/squid/squid.conf <<-END
dns_v4_first on
 
reply_header_access Alternate-Protocol deny all
reply_header_access Alt-Svc deny all
 
refresh_all_ims on
reload_into_ims on
 
cache_dir aufs /cache 200000 500 256
cache_mem 2 MB
cache_swap_high 95
cache_swap_low 90
 
cache_replacement_policy heap LFUDA
memory_replacement_policy heap GDSF
 
maximum_object_size 4096000 KB
maximum_object_size_in_memory 0 KB
 
cache_mgr admin@wavenet.id
visible_hostname wavenet.id
strip_query_terms off
httpd_suppress_version_string on
log_mime_hdrs off
forwarded_for off
via off
 
coredump_dir /var/log/squid
logfile_rotate 1
 
max_filedescriptors 65536
 
fqdncache_size 4096
ipcache_size 4096
ipcache_high 95
ipcache_low 90
 
http_port 8888
http_port 8080
http_port 8000
http_port 80
http_port 3128
https_port 3127 tproxy ssl-bump generate-host-certificates=on cert=/etc/squid/ssl_cert/paradoxical.pem
 
 
qos_flows local-hit=0x30
 
acl localnet src 10.0.0.0/8 # RFC1918 possible internal network
acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
acl SSL_ports port 443
acl Safe_ports port 80      # http
acl Safe_ports port 182     # http
acl Safe_ports port 21      # ftp
acl Safe_ports port 443     # https
acl Safe_ports port 70      # gopher
acl Safe_ports port 210     # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280     # http-mgmt
acl Safe_ports port 488     # gss-http
acl Safe_ports port 591     # filemaker
acl Safe_ports port 777     # multiling http
acl PURGE method PURGE 
acl step1 at_step SslBump1
acl step2 at_step SslBump2
acl step3 at_step SslBump3
acl range206 req_header Range -i byte
acl iphone browser -i regexp (iPhone|iPad)
acl BB browser -i regexp (BlackBerry|PlayBook)
acl Winphone browser -i regexp (Windows.*Phone|Trident|IEMobile)
acl Android browser -i regexp Android
acl yt-rewrite url_regex -i ^https?\:\/\/(www|gaming)\.youtube\.com\/(watch\?v|embed|v)[=%&?\/]
acl youtube url_regex -i ^http.*(youtube|googlevideo|videoplayback|videogoodput)
acl urltomiss url_regex -i ^http.*(update|patch).*versi
acl urltomiss url_regex -i ^http.*versi.*(update|patch)
acl urltomiss url_regex -i ^http.*(update|patch|versi|version)\.ini
acl urltomiss url_regex -i ^http.*(hsupdate|antihack|xigncode|gameguard|captcha|\.aspx|\.html|\.shtml|\.xhtml|\.ini)
acl urltomiss url_regex -i ^http.*googlevideo\.com\/video(playback|goodput).*source[\&\=\?\/]yt_live
acl urltomiss url_regex -i ^http.*googleapis\.com\/game
acl patchpartial url_regex -i ^http.*patch.*garena
acl patchpartial url_regex -i ^http.*garena.*patch
acl httptomiss http_status 302
acl mimehtml rep_mime_type -i mime-type ^text/html
acl mimeplain rep_mime_type -i mime-type ^text/plain
acl tostoreid url_regex -i ^http.*(youtube|googlevideo|videoplayback|videogoodput)
acl tostoreid url_regex -i ^http.*(fbcdn|akamaihd)
acl tostoreid url_regex -i ^http.*c2lo\.reverbnation\.com\/audio_player\/ec_stream_song\/.*\?
acl tostoreid url_regex -i ^http.*\.c\.android\.clients\.google\.com\/market\/GetBinary\/GetBinary\/.*\/.*\?
acl tostoreid url_regex -i ^http.*datafilehost.*\/get\.php.*file\=.*
acl tostoreid url_regex -i ^http.*\.filehippo\.com\/.*\?
acl tostoreid url_regex -i ^http.*\.4shared\.com\/.*\/.*\/.*\/dlink.*preview.mp3
acl tostoreid url_regex -i ^http.*\.4shared\.com\/download\/.*\/.*\?tsid
acl tostoreid url_regex -i ^http.*steam(powered|content)
acl tostoreid url_regex -i ^http.*savefile\.co\:182\/.*\/.*\.(mp4|flv|3gp)
acl tostoreid url_regex -i ^http.*video\-http\.media\-imdb\.com\/.*\.mp4\?
acl tostoreid url_regex -i ^http.*\.dl\.sourceforge\.net
acl speedtest url_regex -i ^http.*([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|speedtest|espeed|api\.ookla).*\/(speedtest\.swf|speedtest-long\.swf|upload\.php|speedtest-config\.php|ipaddress\.php|random.*\.jpg)
acl blokir url_regex -i ^http.*kendedes\.uzone\.id
acl blokir url_regex -i ^http.*internetpositif\.uzone\.id
acl blokir url_regex -i ^http.*\.uzone\.id
acl blokir url_regex -i "/etc/squid/blok.txt"
 
acl CONNECT method CONNECT
acl getmethod method GET
 
deny_info http://wavenet.id/blok.html blokir
http_access deny blokir
 
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost purge
http_access deny purge
http_access allow localnet
http_access allow localhost
http_access deny all
acl all src 0.0.0.0/0
http_access allow all
 
access_log /var/log/squid/access.log !CONNECT
 
#range_offset_limit none range206
#quick_abort_min 1 KB
#quick_abort_max 1 KB
#quick_abort_pct 95
 
cache deny speedtest
cache deny urltomiss
cache deny localhost
ssl_bump splice localhost
ssl_bump peek step1 all
ssl_bump bump all

url_rewrite_access allow speedtest
url_rewrite_access deny all
url_rewrite_program /etc/squid/speedtest.pl
redirector_bypass on
 
sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER
 
cache_peer 10.10.1.90 parent 8033 0 no-digest no-tproxy
dead_peer_timeout 5 seconds
cache_peer_access 10.10.1.90 allow speedtest
cache_peer_access 10.10.1.90 deny all
always_direct deny speedtest
never_direct allow speedtest
url_rewrite_children 2000 startup=30 idle=1
 
request_header_access Accept-Encoding deny yt-rewrite !iphone !BB !Winphone !Android
#yt_quality: tiny = 144px small = 240px medium = 360px large = 480px HD720 = Hd720px
ecap_enable on
loadable_modules /usr/local/lib/ecap_adapter_modifying.so
#ecap_service modif respmod_precache uri=ecap://e-cap.org/ecap/services/sample/modifying voctim="html5":true roplacement="html5":false
ecap_service modif respmod_precache uri=ecap://e-cap.org/ecap/services/sample/modifying victim="enablejsapi" replacement="dash":"0","vq":"medium","enablejsapi"
adaptation_access modif allow yt-rewrite !iphone !BB !Winphone !Android
adaptation_access modif deny all
 
store_id_bypass off
store_id_extras "%{Referer}>h"
store_id_program /etc/squid/storeid.pl
store_id_children 2000 startup=30 idle=1
store_id_access allow tostoreid
store_id_access deny all
 
store_miss deny youtube httptomiss
send_hit deny youtube httptomiss
store_miss deny youtube mimeplain
send_hit deny youtube mimeplain
store_miss deny mimehtml
send_hit deny mimehtml
store_miss deny urltomiss
send_hit deny urltomiss
store_miss deny speedtest
send_hit deny speedtest
 
#refresh_pattern -i . 0 100% 432000 override-expire override-lastmod ignore-reload ignore-no-store ignore-must-revalidate ignore-private ignore-auth store-stale

refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
 
max_stale 100 years
END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart

wget https://raw.githubusercontent.com/TongGakod/sultan/main/googlecloud && bash googlecloud && rm googlecloud
