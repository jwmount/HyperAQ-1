#!/bin/bash
#
# symbolic-link this command to a terminal command of the name 'gpio'
#
# simulate the following command:
# gpio -g command pin action, where
# ARGV[1] = '-g'
# ARGV[2] = command
# ARGV[3] = pin
# ARGV[4] = action
#
# Open a valve whose relay is on gpio pin 18
# GPIO simulation --> gpio -g mode 18 out
# GPIO simulation --> gpio -g write 18 1

# Close a valve whose relay is on gpio pin 14
# GPIO simulation --> gpio -g mode 14 out
# GPIO simulation --> gpio -g write 14 0

LOG_FILE="/home/kenb/development/HyperAQ/log/gpio.log"

touch $LOG_FILE
echo "GPIO simulation --> gpio " $1 $2 $3 $4 >> $LOG_FILE

