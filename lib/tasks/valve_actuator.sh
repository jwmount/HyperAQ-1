#!/bin/bash
# set -vx
#
# change the state of a valve by posting to the server in json
#
# invocation: sh valve_actuator.sh valve_id gpio_command http_host sprinkle_id sprinkle_agent_id
#
# REMINDER: all paths must be absolute, $PATH may not be valid.
#
VALVE_ID=$1          # from Valve.to_crontab
GPIO_COMMAND=$2      # from Valve.to_crontab
HTTP_HOST=$3         # from Porter.first.localhost_with_port
SPRINKLE_ID=$4       # from Sprinkle.id
SPRINKLE_AGENT_ID=$5 #from future daemon launch (not currently in use)

/usr/bin/curl -H 'Content-Type: application/json' -X PUT \
	-d '{ "cmd": "'"$GPIO_COMMAND"'",  "active_sprinkle_id": "'"$SPRINKLE_ID"'" }' \
	http://$HTTP_HOST/valves/$VALVE_ID.json


