#!/bin/bash
#
rm log/*.log

crontab -r
touch lib/tasks/crontab
rm lib/tasks/crontab

bundle update
sh dev-bounce-db.sh
# sh dev-start.sh 
rails s
