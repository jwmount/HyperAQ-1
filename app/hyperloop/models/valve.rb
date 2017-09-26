require 'models/application_record'

class Valve < ApplicationRecord
  has_many :sprinkles
  has_many :lists 
 
  if RUBY_ENGINE != 'opal'
    require 'time'

    # Valve cmds
    OFF = 0
    ON = 1
    commands = %w{ OFF ON }

    LOGFILE = "log/valve.log"

    def log(msg)
      f = File.open(LOGFILE, 'a')
      f.write msg
      f.close
    end

    # send command(s) to Raspberry PI GPIO pins (using WiringPI global shell command, gpio)
    def command(val)
      # record the valve's command state in the db
      update(cmd: val)
      mode = "gpio -g mode #{gpio_pin} out"
      write = "gpio -g write #{gpio_pin} #{val}"
      system(mode)
      system(write)
    end

    # # answer a set of parameters needed by the actuator script
    # def to_crontab(sprinkle, state)
    #   "%2d %2d" % [sprinkle.id, state] 
    # end

    def start
      command(ON) 
      log "\nValve #{id}, #{name} start, cmd --> #{cmd}\n"
      # start a new history
      List.new.start(id)
    end

    def stop
      command(OFF) 
      log "Valve #{id}, #{name} stop,  cmd --> #{cmd}\n"
      # complete the history 
      history = List.find(active_history_id)
      history.stop
    end

  end # RUBY_ENGINE
end

