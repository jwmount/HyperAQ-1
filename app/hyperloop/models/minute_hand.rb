require 'models/application_record'
class MinuteHand < ApplicationRecord

# MERGE THIS CODE WITH MINUTE_HAND_SERVER SERVER_OP AND THEN ELIMINATE THE MINUTE_HAND MODEL
  if RUBY_ENGINE != 'opal'

    CRONTAB = 0
    PROCESS = 1

    LOGFILE = "log/minute_hand.log"
    LOG_TIME = "%H:%M:%S"

      def log_time
        Time.now.strftime(LOG_TIME)
      end

      def log(msg)
        f = File.open(LOGFILE, 'a')
        f.write msg
        # f.write "#{log_time} #{msg}"
        f.close
      end

    def manipulate_and_update(params)
      # 
      # check to see if any sprinkles are ready to be started or stopped
      #
      t = Time.now
      master_start = Time.new(t.year, t.mon, t.mday, t.hour, t.min, 0)

      # list = Sprinkle.where("start_time = #{master_start}")
      log "MinuteHand.find(1).manipulate_and_update, time --> #{master_start.strftime(LOG_TIME)}\n"
      return true
    end

    def minute_hand_crontab_line
      ""
    end

  end # RUBY_ENGINE

end
