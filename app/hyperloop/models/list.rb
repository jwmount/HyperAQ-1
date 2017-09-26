require 'models/application_record'
class List < ApplicationRecord # Treat this as History, since Opal inflection problems broke with 'History', but work with 'List'

  default_scope { order(start_time: :desc) }
  belongs_to :valve


  LOGFILE = "log/history.log"

  def log(msg)
    f = File.open(LOGFILE, 'a')
    f.write msg
    f.close
  end

  SECONDS_PER_HOUR = 60*60
  SECONDS_PER_DAY = 24*SECONDS_PER_HOUR
  SECONDS_PER_WEEK = SECONDS_PER_DAY * 7
  PRUNE_INTERVAL = SECONDS_PER_WEEK 
  TIME_INPUT_STRFTIME = "%a %d %b %l:%M %P"

  # Create an instance of History, using valve_id of the owning valve_id as initialization parameter
  def start(valve_id)
    valve = Valve.find(valve_id)
    log "\nhistory.start, #{valve.name}\n"
    update(start_time: Time.now, start_time_display: Time.now.strftime(TIME_INPUT_STRFTIME), stop_time_display: ' ', valve_id: valve_id)
    valve.update(active_history_id: id)
  end

  # Complete the history
  def stop
    # log "history.stop, valve_id --> #{valve_id}\n"
    valve = Valve.find(valve_id)
    log "history.stop, #{valve.name}\n"
    update(stop_time_display: Time.now.strftime(TIME_INPUT_STRFTIME))
    valve.update(active_history_id: 0)
  end

  # Delete entries older than Time.now - PRUNE_INTERVAL
  def self.prune
    List.where((Time.now - start_time) > PRUNE_INTERVAL).destroy_all
  end

end
