#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

[ "$1" == "help" ] && echo "HELP: files count sensor, options: [SENSOR NAME] [WARN|ALERT] [ALERT|WARN VALUE] [ALERT|WARN TOP|BOTTOM] [PATH] [EXT1,EXT2,EXTn,...]" && exit 0

[ -z "$1" ] && _sensor_name="files" || _sensor_name="files_"$1
_sensor_status="CHECKING"

#### CONTROL INPUT PARAMETERS ####

[ "$2" == "ALERT" ] && _sensor_control="ALERT" || _sensor_control="MARK"
[ -z "$3" ] && _sensor_ctrl_value="0" || _sensor_ctrl_value=$3
[ "$4" == "BOTTOM" ] && _sensor_ctrl_thr="BOTTOM" || _sensor_ctrl_thr="TOP"
[ -z "$5" ] && _sensor_status="DISABLE no path" || _sensor_dir=$5
[ -z "$6" ] && _sensor_status="DISABLE no ext" || _sensor_ext=$6

#### CONTROL SENSORS COMMAND YOU NEED ####

[ ! -d "$_sensor_dir" ] && _sensor_status="DISABLE no path"

#### SCRIPT WHAT EVER YOU WANT, BUT CONTROL COMMANDS OUTPUTS ONLY ALLOW STANDART OUPUT FOR THE LAST MANDATORY LINE ####

if [ "$_sensor_status" == "CHECKING" ]
then
	_sensor_status=$( ls -1 $_sensor_dir"/" | awk -v _ext="$_sensor_ext" -v _tsns="$_sensor_control" -v _tval="$_sensor_ctrl_value" -v _tthr="$_sensor_ctrl_thr" '
		BEGIN { 
			_c=0 ; 
			_le=split(_ext,type,",") 
		} { 
			for(i=1;i<=_le;i++) { 
				if ( $0 ~ type[i]"$" ) { _c++ ; break } 
			}
		} END { 
			_status="OK"
			if ( _tthr == "BOTTON" ) {
				if ( _c < _tval ) { 
					_status=_tsns
				} else {
					_status="UP"
				}
			}
			if ( _tthr == "TOP" ) {
				if ( _c > _tval ) {
					_status=_tsns
				} else {
					_status="UP"
				}
			}
			print _status" "_c 
		}' ) 
fi

#### MANDATORY COMMAND HERE:

echo $_sensor_name":"$_sensor_status"@"

#### _sensor_status cant get this values and format:
# FIRST FIELD ( SPACE SEPARATED ) : STATUS OF THE SENSOR, ADMITED VALUES: [UP,OK,MARK,FAIL,DOWN,CHECK] or blank value.
#      UP|OK: are tratable by cyclops I.A like positive status of the sensor and web, command output designated color
#      FAIL|DOWN: are tratable by cyclops I.A. like negative status of the sensor and web, command output designated color
#      MARK|CHECK: are ignored by cyclops I.A. but have special color format web gui and command output 
#      [blank]: cyclops ignore sensor status and it hasn't designated ouput color.
# SECOND FIELD: [alphanumeric text message, exclude "@" character and special ones] or [numeric values to get future statistics]
#      alphanumeric examples: [no cmd|na|no value|err|...]
#      numeric examples: [35%|325|4/4] thins values are cyclops statistics comprensible
#      numeric examples: [10/10/10|4/2/11/12|...] thins are NOT cyclops statistics comprensible
#
# examples:
#
# _sensor_status="UP"
# _sensor_status="OK 35%"
# _sensor_status="DOWN fail service"


