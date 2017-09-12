#!/bin/bash
#
rm log/*.log
bundle update
sh dev-bounce-db.sh
# sh dev-start.sh 
rails s
