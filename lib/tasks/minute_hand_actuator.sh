#!/bin/bash
# set -vx
# sh minute_hand_actuator.sh localhost:3000 1 99
#
# send an update to minute_handchange the state of a sprinkle by posting to the server in json
#
# invocation: sh sprinkle_actuator.sh http_host minute_hand_id key 
#
# REMINDER: all paths must be absolute, $PATH may not be valid.
#
HTTP_HOST=$1
MINUTE_HAND_ID=$2
KEY=$3
/usr/bin/curl -H 'Content-Type: application/json' -X PUT -d '{ "key": "'"$KEY"'" }' http://$HTTP_HOST/minute_hands/$MINUTE_HAND_ID.json


