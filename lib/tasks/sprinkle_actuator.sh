#!/bin/bash
# set -vx
#
# change the state of a sprinkle by posting to the server in json
#
# invocation: sh sprinkle_actuator.sh http_host sprinkle_id state 
#
# REMINDER: all paths must be absolute, $PATH may not be valid.
#
HTTP_HOST=$1
SPRINKLE_ID=$2
STATE=$3
/usr/bin/curl -H 'Content-Type: application/json' -X PUT -d '{ "state": "'"$STATE"'" }' http://$HTTP_HOST/sprinkles/$SPRINKLE_ID.json


