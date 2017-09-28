class MinuteHandServer < Hyperloop::ServerOp
  
  param :acting_user, nils: true
  param :key
  dispatch_to { Hyperloop::Application }


  step do 
    minute_hand_update (params.key)
  end
  
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
  #
  # manual valve update behavior
  #
  # All valve operations are toggles, so if a valve is ON, then a manual activation will turn it OFF.
  #
  def minute_hand_update(key)
    #iterate through sprinkles table...
    log "MinuteHandServer step minute_hand_update(#{key}), @#{log_time}\n"
  end

end 

