#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_apc_output' to get data to process

_sensor_string="APC Line V"

_sensor_status=$( echo "${_sensor_apc_output}" | awk -F" : " '
	{ 
		gsub(/ +$/,"",$1) ; 
		gsub(/^ +/,"",$2) ; 
		gsub(/ +$/,"",$2) 
	} $1 == "LINEV" { 
		split($2,f," ") ; 
		if ( f[1] < 220 || f[1] > 230 ) { _st="MARK" } else { _st="UP" }
		print _st" "f[1] 
	}' )

echo $_sensor_string":"$_sensor_status
