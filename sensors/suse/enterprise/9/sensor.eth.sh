#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

[ "$1" == "help" ] && echo "HELP: sensor options: [SENSOR NAME] [ETH DEVICE] [% WARNING LEVEL] [TMP DIR/FILE] [MAX SPEED mb] [per|bit|KB|MB|GB]" && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

_cmd_ethtool=$( which ethtool 2>/dev/null )

_netdev=$2
[ -z "$3" ] && _warn_level="30" || _warn_level=$3
[ -z "$4" ] && _tmp_file="/tmp/$_netdev.cyc" || _tmp_file=$4
_net_maxout=$5
[ -z "$6" ] && _out_msr="per" || _out_msr=$6

if [ -z "$_cmd_ethtool" ]
then
	_sensor_status="DISABLE no cmd"
else
	_ifstatus=$( ip link | awk -v _if="$_netdev" '$0 ~ _if":" { _st=gensub(/<(.*)>/,"\\1","g",$3) ;  split(_st,d,",") ; if ( d[1] == "LOOPBACK" ) { print d[2] } else { if ( d[3] == "SLAVE" || d[3] == "MASTER" ) { print d[4] } else { print d[3] }}}' )

	if [ -f "$_tmp_file" ] && [ "$_ifstatus" == "UP" ] 
	then
		_net_top=$( $_cmd_ethtool $( echo $_netdev | cut -d'@' -f1 ) 2>/dev/null | awk '$0 ~ "Speed" { sub(/....$/,"",$2) ; print $2 }' )
		_net_ini=$( cat $_tmp_file )
		_net_thr=$( stat -c %Z $_tmp_file )
		_net_end=$( awk -v _nd="$_netdev" 'BEGIN { split(_nd,ifce,"@") } $1 ~ ifce[1] { print $2";"$10 }' /proc/net/dev )
		_net_vel=$( echo "dummie" | awk -F\; -v _lt="$_net_thr" -v _ini="$_net_ini" -v _end="$_net_end" -v _top="$_net_top" -v _wl="$_warn_level" -v _om="$_out_msr" '
                                BEGIN {
                                        if ( _top == "" ) {
                                                _st="DISABLE no max"
                                                exit
                                        } else {
                                                split(_ini,i,";") ;
                                                split(_end,e,";") ;
                                                _st="UP" ;
                                                _top=(_top*1024*1024)/8
                                                _ts=systime() ;
                                                _tt=_ts-_lt
                                        }
                                } {
                                        if ( _tt != 0 ) {
                                                _inper=int(((((e[1]-i[1])/_tt)*100)/_top)) ; _outper=int(((((e[2]-i[2])/_tt)*100)/_top))
                                                if ( _om == "per" ) { _in=_inper ; _out=_outper }
                                                if ( _om == "bits" ) { _in=e[1]-i[1] ; _out=e[2]-i[2] }
                                                if ( _om == "KB" ) { _in=int((((e[1]-i[1])/8)/1024)) ; _out=int((((e[2]-i[2])/8)/1024)) }
                                                if ( _om == "MB" ) { _in=int((((e[1]-i[1])/8)/1024^2)) ; _out=int((((e[2]-i[2])/8)/1024^2)) }
                                                if ( _om == "GB" ) { _in=int((((e[1]-i[1])/8)/1024^3)) ; _out=int((((e[2]-i[2])/8)/1024^3)) }
                                        } else {
                                                _in=0
                                                _out=0
                                        }
                                } END {
                                        if ( _st ~ "DISABLE" ) {
                                                print _st
                                        } else {
                                                if ( _inper > _wl || _outper > _wl ) { _st="MARK" } ;
                                                print _st" "_in"/"_out
                                        }
                                }' )
		_sensor_status=$_net_vel
                echo $_net_end > $_tmp_file
	else
		if [ "$_ifstatus" == "UP" ]
		then
			_net_end=$( awk -v _nd="$_netdev" '{ sub(/:/,"",$1) } $1 == _nd { print $2";"$10 }' /proc/net/dev )
			_net_vel="DISABLE"
		else
			[ -z "$_ifstatus" ] && _net_vel="DISABLE no if" || _net_vel=$_ifstatus
		fi
	fi

	echo $_net_end > $_tmp_file 

	_sensor_status=$_net_vel
fi

echo $_sensor_name":"$_sensor_status"@"
