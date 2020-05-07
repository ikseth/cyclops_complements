#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

[ "$1" == "help" ] && echo "HELP: sensor options: [SENSOR NAME] [LOGDIR] [LOGFILE] [WARN|FAIL] [TMPFILE] [STRING1,STRING2,...]" && exit 0


_sensor_status="CHECKING"

[ -z "$1" ] && _sensor_name="a2log" || _sensor_name="a2log_"$1
[ -z "$2" ] && _logdir="/var/log/apache2" || _logdir=$2
[ -z "$3" ] && _logfile="access_log" || _logfile=$3
[ "$4" == "FAIL" ] && _snsmsg="FAIL" || _snsmsg="WARN"
[ -z "$5" ] && _logtmp_file="/tmp/$_sensor_name.cyc" || _logtmp_file=$5
[ -z "$6" ] && _logstr="GET" || _logstr=$6

if [ -f "$_logtmp_file" ] && [ -f "$_logdir/$_logfile" ] 
then
	_time_thr=$( stat -c %Z $_logtmp_file )
	_sensor_status=$( awk -v _tr="$_time_thr" -v _sm="$_snsmsg" -v _ls="$_logstr" '
		BEGIN { 
			_now=systime() ; 
			_ny=strftime("%Y",_now)
			_st="UP" ;
			_ns=split(_ls,s,",") 
			_err=0 
		} {
			_pardate=gensub(/\[([0-9][0-9])\/([A-Z][a-z][a-z])\/([0-9][0-9][0-9][0-9]):([0-9][0-9]):([0-9][0-9]):([0-9][0-9])/,"\\1 \\2 \\3 \\4 \\5 \\6","g",$4) ; 
			gsub( "Jan","01",_pardate ) ;
			gsub( "Feb","02",_pardate ) ;
			gsub( "Mar","03",_pardate ) ;
			gsub( "Apr","04",_pardate ) ; 
			gsub( "May","05",_pardate ) ;
			gsub( "Jun","06",_pardate ) ;
			gsub( "Jul","07",_pardate ) ;
			gsub( "Aug","08",_pardate ) ;
			gsub( "Sep","09",_pardate ) ;
			gsub( "Oct","10",_pardate ) ;
			gsub( "Nov","11",_pardate ) ;
			gsub( "Dec","12",_pardate ) ;
			split(_pardate,dt," ") ;
			_ts=mktime( dt[3]" "dt[2]" "dt[1]" "dt[4]" "dt[5]" "dt[6] ) ;
		} _ts > _tr && _ts < _now { 
			for (i=1;i<=_ns;i++) {
				if ( $0 ~ s[i] ) {
					_err++ ; 
				}
			}
		} END { 
			if ( _err == "0" ) { _st="UP" ; _err="" } else { _st=_sm }
			print _st" "_err 
		}' $_logdir/$_logfile )
else
	
	[ ! -f "$_logtmp_file" ] && _sensor_status="DISABLE notime"
	[ ! -f "$_logdir/$_logfile" ] && _sensor_status="MARK nolog"	
fi

echo $( date +%s ) > $_logtmp_file

echo $_sensor_name":"$_sensor_status"@"
