#!/bin/bash
#@HELP@
#@SCOPY@
#@LOCAL@

[ "$1" == "help" ] && echo "HELP: sensor description, options: [SENSOR NAME] [OPT1] [OPT2] [OPT3]" && exit 0

_sensor_name=$1
_sensor_status="CHECKING"

#### CONTROL INPUT PARAMETERS ####

[ -z "$2" ] && _opt1_value="by default" || _opt1_value=$2

#### CONTROL SENSORS COMMAND YOU NEED ####

_cmd01=$( which command 2>/dev/null )
[ -z "$_cmd01" ] && do something

#### SCRIPT WHAT EVER YOU WANT, BUT CONTROL COMMANDS OUTPUTS ONLY ALLOW STANDART OUPUT FOR THE LAST MANDATORY LINE ####

scripting all the time in this part, output send to files or variables

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


