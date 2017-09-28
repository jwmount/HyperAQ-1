require 'models/application_record'

class Valve < ApplicationRecord
  has_many :sprinkles
  has_many :lists 
 
  if RUBY_ENGINE != 'opal'
    require 'time'

    # Valve cmds
    OFF = 0
    ON = 1
   
    LOGFILE = "log/valve.log"

    def log(msg)
      f = File.open(LOGFILE, 'a')
      f.write msg
      f.close
    end

    def start
      command(ON) 
      log "\n#{name} start, cmd --> #{commands(cmd)}\n"
      # start a new history
      List.new.start(id)
    end

    def stop
      command(OFF) 
      log "#{name} stop,  cmd --> #{commands(cmd)}\n"
      # complete the history 
      history = List.find(active_history_id)
      history.stop
    end

    private

      def commands(index)
        %w{ OFF ON }[index]
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

  end # RUBY_ENGINE
end

