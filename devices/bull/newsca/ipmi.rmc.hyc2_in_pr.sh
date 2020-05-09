#! /bin/bash
# IPMI SCRIPT SENSOR use '_sensor_ipmi_output' to get data to process

_sensor_string="HYB_2 Inlet Pr"

_sensor_down=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _st="$_sensor_string" '$1 ~ _st { print ($5*100)/$8 }' )
_sensor_fail=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _st="$_sensor_string" '$1 ~ _st { print ($6*100)/$8 }' )
_sensor_up=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _st="$_sensor_string" '$1 ~ _st { print ($7*100)/$8 }' )

_sensor_output=$( echo "${_sensor_ipmi_output}" | awk -F\| -v _test="$_sensor_string" -v _sd="$_sensor_down" -v _sf="$_sensor_fail" -v _su="$_sensor_up" '
		BEGIN {
			_s=0 ;
			_su=_su+0 ;
			_sf=_sf+0 ;
			_sd=_sd+0 ;
		} $1 ~ _test { 
			_t=($2*100)/$8 ; 
			gsub(/\.[0-9]+$/,"",_t) ; 
			_t=_t+0 ;
		} END { 
			if ( _t <= _sd ) { _t="DOWN "_t"%" ; _s=1 }
			if ( _t >= _sf && _t <= _sf && _s == 0 ) { _t="FAIL "_t"%" ; _s=1 }
			if ( _t >= _su && _t < 100 && _s == 0 ) { _t="UP "_t"%" ; _s=1 }
			if ( _t >= 100 && _s ==0 ) { _t="MARK "_t"%" ; _s=1 }
			if ( _t == "" ) { _t="DISABLE sensor miss" ; _s=1 }
			if ( _s == 0 ) { _t="UNKNOWN "_t }
			print _t ;
		}' )

_sensor_status=$_sensor_output

echo $_sensor_string":"$_sensor_status
