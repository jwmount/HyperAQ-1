#!/bin/bash
# set -vx
#
# change the state of a valve by posting to the server in json
#
# invocation: sh sprinkle_actuator.sh valve_id gpio_command http_host sprinkle_id sprinkle_agent_id
#
# REMINDER: all paths must be absolute, $PATH may not be valid.
#
HTTP_HOST=$1
SPRINKLE_ID=$2
STATE=$3
KEY=$4
SPRINKLE_AGENT_ID=$5
/usr/bin/curl -H 'Content-Type: application/json' -X PUT -d '{ "state": "'"$STATE"'",  "sprinkle_agent_id": "'"$SPRINKLE_AGENT_ID"'", "key": "'"$KEY"'" }' http://$HTTP_HOST/sprinkles/$SPRINKLE_ID.json


