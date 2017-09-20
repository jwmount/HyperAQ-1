#!/bin/bash
#
# this script contains a history of all the rails generate commands used to build this app.  They can be repeated 
# individually if it is necessary to modify a model's attributes
#
bundle install
rails g model List start_time:datetime start_time_display:string stop_time_display:string valve_id:integer --force
rails g model Sprinkle next_start_time_display:string next_start_time:datetime state:integer time_input:string duration:integer valve_id:integer state:string --force
rails g scaffold Valve name:string gpio_pin:integer active_sprinkle_id:integer active_history_id:integer cmd:integer  --force
rails g model WaterManager state:string --force
rails g scaffold Porter host_name:string port_number:string --force

sh dev-bounce-db.sh
rails g hyperloop:install
rails g hyper:component App
rails g hyper:component HistoryList
rails g hyper:component HistoryRow
rails g hyper:component Layout
rails g hyper:component Navbar
rails g hyper:component PorterStatus
rails g hyper:component SprinkleList
rails g hyper:component SprinkleRow
rails g hyper:component TitleNav
rails g hyper:component ValveButton
rails g hyper:component ValveButtons
rails g hyper:component WaterStatus
