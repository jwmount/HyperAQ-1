#!/bin/bash
# set -vx
#
# change the state of a valve by posting to the server in json
#
# invocation: sh valve_actuator.sh valve_id gpio_command http_host 
#
# REMINDER: all paths must be absolute, $PATH may not be valid.
#
VALVE_ID=$1
CMD=$2
HTTP_HOST=$3
SPRINKLE_ID=$4
/usr/bin/curl -H 'Content-Type: application/json' -X PUT -d '{ "cmd": "'"$CMD"'",  "active_sprinkle_id": "'"$SPRINKLE_ID"'" }' http://$HTTP_HOST/valves/$VALVE_ID.json


