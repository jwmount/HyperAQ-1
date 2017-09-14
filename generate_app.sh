bundle install
rails g model List start_time:datetime start_time_display:string stop_time_display:string valve_id:integer --force
rails g model Sprinkle next_start_time_display:string next_start_time:datetime state:integer time_input:string duration:integer valve_id:integer state:string --force
rails g scaffold Valve name:string gpio_pin:integer active_sprinkle_id:integer active_history_id:integer cmd:integer  --force
# rails g model WaterManager state:string --force
rails g scaffold Porter host_name:string port_number:string --force

sh dev-bounce-db.sh
rails g hyperloop:install
rails g hyper:component App


