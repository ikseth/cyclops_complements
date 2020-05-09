#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_apc_output' to get data to process

_sensor_string="APC Device Load"

_sensor_status=$( echo "${_sensor_apc_output}" | awk -F" : " '
	BEGIN { 
		_st="DISABLE"
	} { 
		gsub(/ +$/,"",$1) ; 
		gsub(/^ +/,"",$2) ; 
		gsub(/ +$/,"",$2) 
	} $1 == "LOADPCT" { 
		split($2,f," ") ; 
		if ( f[1] <= 20 ) { _st="OK" }
		if ( f[1] > 20 && f[1] < 50 ) { _st="UP" }
		if ( f[1] >= 50 && f[1] <= 90 ) { _st="MARK" }
		if ( f[1] > 90 ) { _st="FAIL" }
		print _st" "f[1] 
	}' )

echo $_sensor_string":"$_sensor_status
