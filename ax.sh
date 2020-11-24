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
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
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
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
acl SSH dst 52.74.223.216-52.74.223.216/255.255.255.255
acl SSH dst 121.123.229.172-121.123.229.172/255.255.255.255
acl SSH dst 178.128.61.6-178.128.61.6/255.255.255.255
acl SSH dst 13.67.73.225-13.67.73.225/255.255.255.255
acl SSH dst 128.199.111.9-128.199.111.9/255.255.255.255
acl SSH dst 159.65.140.10-159.65.140.10/255.255.255.255
acl SSH dst 178.128.219.61-178.128.219.61/255.255.255.255
acl SSH dst 128.199.198.111-128.199.198.111/255.255.255.255
acl SSH dst 115.164.5.48-115.164.5.48/255.255.255.255
acl SSH dst 115.164.14.11-115.164.14.11/255.255.255.255
acl SSH dst 121.123.228.74-121.123.228.74/255.255.255.255
acl SSH dst 13.250.162.203-13.250.162.203/255.255.255.255
acl SSH dst 202.76.228.246-202.76.228.246/255.255.255.255
acl SSH dst 52.112.196.11-52.112.196.11/255.255.255.255
acl SSH dst 13.32.240.128-13.32.240.128/255.255.255.255
acl SSH dst 121.123.232.73-121.123.232.73/255.255.255.255
acl SSH dst 3.1.163.59-3.1.163.59/255.255.255.255
# DNS OPTIONS
#dns_packet_max 4096
dns_defnames on
dns_v4_first on
dns_nameservers 192.168.1.200 127.0.0.1
connect_retries 2
negative_dns_ttl 1 second
range_offset_limit none
quick_abort_min -1 KB
quick_abort_max 0
quick_abort_pct 80
ipcache_low 98
ipcache_high 99
ipcache_size 1024
fqdncache_size 512
pipeline_prefetch 0
 
# MISCELEANOUS
memory_pools off
# refresh_all_ims on
reload_into_ims on
max_filedescriptors 65536
 
# CACHE MANAGEMENT
cache_mem 256 MB
maximum_object_size_in_memory 32 KB
memory_replacement_policy heap GDSF
cache_effective_group proxy
cache_effective_user proxy
cache_dir aufs /cache/cache 50000 1 256
coredump_dir /cache/cache
cache_mgr kangmus
visible_hostname kangmus
minimum_object_size 0 KB
maximum_object_size 512 MB
read_ahead_gap 64 KB   
cache_replacement_policy heap LFUDA
store_dir_select_algorithm least-load
strip_query_terms off
cache_swap_high 90
cache_swap_low 95
 
# LOG FILE OPTIONS
acl log method CONNECT
logfile_daemon /usr/lib/squid/log_file_daemon
access_log daemon:/var/log/squid/access.log !CONNECT
# cache_log /var/log/squid/cache.log
# cache_store_log /var/log/squid/store.log
# debug_options ALL,1 22,3
cache_store_log none
logfile_rotate 3
pid_filename /var/run/squid.pid

# ======================================================================================================== 
# FILTERING HTTPS
# ======================================================================================================== 
url_rewrite_program /etc/squid/squidrewrite

acl rewritedoms dstdomain .dailymotion.com .video-http.media-imdb.com .dl.sourceforge.net .prod.video.msn.com .fbcdn.net .akamaihd.net vl.mccont.com .mais.uol.com.br .streaming.r7.com
acl yt url_regex -i googlevideo.*videoplayback
acl speedtest url_regex -i ^https?:\/\/(.*?)\/speedtest\/.*\.(jpg|txt|png|gif|swf)\?.*
acl speedtest url_regex -i speedtest\/.*\.(jpg|txt|png|gif|swf)\?.*
acl yt url_regex http_status 302
acl gmaps url_regex -i ^https?:\/\/(khms|mt)[0-9]+\.google\.[a-z\.]+\/.*
acl ttv url_regex -i terratv
acl globo url_regex -i ^http:\/\/voddownload[0-9]+\.globo\.com.*
acl dm url_regex -i dailymotion\-flv2
acl getmethod method GET
 
acl store_url url_regex -i (youtube|googlevideo|docs.google|video.google).*videoplayback\?.*
acl loop_302 http_status 302
acl loop_mime rep_mime_type text/html
acl loop_mime rep_mime_type text/plain
acl getmethod method GET
 
store_miss deny store_url loop_302
store_miss deny store_url loop_mime
send_hit deny store_url loop_302
send_hit deny store_url loop_mime

ssl_bump splice localhost
acl 9 at_step SslBump1
acl 10 at_step SslBump2
acl 11 at_step SslBump3
ssl_bump peek 9 all
ssl_bump stare 10 all
ssl_bump splice 11 all

sslcrtd_program /usr/lib/squid/ssl_crtd -s /etc/squid/ssl_db -M 4MB
sslcrtd_children 16 startup=1 idle=1
sslproxy_cert_error allow all
always_direct allow all
ssl_unclean_shutdown on

# STORE ID
store_id_program /etc/squid/squid-cache -file /etc/squid/squid-cache.txt
store_id_extras "%>a/%>A %un %>rm myip=%la myport=%lp referer=%{Referer}>h"
store_id_children 40 startup=10 idle=5 concurrency=0
store_id_access deny !getmethod
store_id_access allow rewritedoms
store_id_access allow speedtest
store_id_access allow yt
store_id_access allow gmaps
store_id_access allow ttv
store_id_access allow globo
store_id_access allow dm
store_id_access deny all
acl all src 0.0.0.0/0
http_access allow all
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localnet
http_access allow localhost
http_access deny all
http_reply_access allow all
icp_access allow all
http_port 8888
http_port 8080
http_port 8000
http_port 80
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname daybreakersx

END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart

wget https://gitlab.com/azli5083/debian8/raw/master/googlecloud && bash googlecloud && rm googlecloud
