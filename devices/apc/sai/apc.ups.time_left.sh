#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_apc_output' to get data to process

_sensor_string="APC Time Left"

_sensor_status=$( echo "${_sensor_apc_output}" | awk -F" : " '
	BEGIN {
		_st="DISABLE" 
	} { 
		gsub(/ +$/,"",$1) ; 
		gsub(/^ +/,"",$2) ; 
		gsub(/ +$/,"",$2) 
	} $1 == "TIMELEFT" { 
		split($2,f," ") ; 
		if ( f[1] > 40 ) { _st="OK" }
		if ( f[1] > 30 && f[1] <= 40 ) { _st="UP" } 
		if ( f[1] > 20 && f[1] <= 30 ) { _st="MARK" }
		if ( f[1] >= 10 && f[1] <= 20 ) { _st="ALERT" }
		if ( f[1] < 10i ) { _st="DOWN" }
		print _st" "f[1] 
	}' )

echo $_sensor_string":"$_sensor_status
