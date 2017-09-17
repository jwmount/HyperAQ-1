require 'models/application_record'

class Valve < ApplicationRecord
  has_many :sprinkles
  has_many :lists 
 
  if RUBY_ENGINE != 'opal'
    require 'time'

    ON = 1
    OFF = 0

    # Sprinkle states
    IDLE = 0
    NEXT = 1
    ACTIVE = 2

    TIME_INPUT_STRFTIME = "%a %d %b %l:%M %P"

    LOGFILE = "log/valve.log"

    def log(msg)
      f = File.open(LOGFILE, 'a')
      f.write msg
      f.close
    end

    # handler for crontab updates to the valves_controller.rb
    #
    # reconciliation with manual valve activity:
    # 
    # 1. If a valve is already ON when the crontab requests arrives, then do nothing.
    def manipulate_and_update(params, valve)
      
      log "\nvalve --> #{valve.name}\n"

      # convert incoming string value of cmd to integer
      cmd = params['cmd'].to_i
      log "cmd --> #{cmd}\n"
      active_sprinkle_id = params['active_sprinkle_id'].to_i
      log "active_sprinkle_id --> #{active_sprinkle_id}\n"
      
      if cmd == ON # start valve sequence
        if valve.cmd == ON 
          return true # do nothing if the valve is already on
        end

        sprinkle = Sprinkle.find(active_sprinkle_id)
        sprinkle.update(state: ACTIVE)
        # log "change sprinkle(#{sprinkle.id}) state to #{sprinkle.state}\n"
        
        history = List.start(valve)
        # log "created a new history @ #{history.start_time_display}\n"
        
        # log "turn on Valve #{valve.name}\n"
        command(ON)
        valve.update(active_history_id: history.id, cmd: ON)
  
      else # stop valve sequence

        sprinkle = Sprinkle.find(active_sprinkle_id)
        st = sprinkle.start_time
        sprinkle.update(state: IDLE, next_start_time: st, next_start_time_display: st.strftime(TIME_INPUT_STRFTIME))
        # log "change sprinkle(#{sprinkle.id}) state to #{sprinkle.state}\n"

        history = List.find(valve.active_history_id)
        history.stop
        # log "update and save 'History' List(#{history.id}) @ #{history.stop_time_display}\n"

        # log "turn off Valve #{valve.name}\n"
        command(OFF)
        valve.update(active_sprinkle_id: nil, active_history_id: nil, cmd: OFF)
        #
        # Finally, prune any History(List) entries older than the PRUNE_INTERVAL
        #
        List.prune
      end
      return true
    end

    # send command(s) to Raspberry PI GPIO pins (using WiringPI global shell command, gpio)
    def command(val)
      log "command(#{val})\n"
      mode = "gpio -g mode #{gpio_pin} out"
      write = "gpio -g write #{gpio_pin} #{val}"
      system(mode)
      system(write)
    end

    # answer a set of parameters needed by rest_client.rb
    def to_crontab(action)
      "%2d %2d" % [id, action] 
    end

  end # RUBY_ENGINE
end

