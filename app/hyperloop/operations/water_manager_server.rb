class WaterManagerServer < Hyperloop::ServerOp
  param :acting_user, nils: true
  param :wm_id #, type: Number
  dispatch_to { Hyperloop::Application }

  step do 
    water_manager_update(params.wm_id)
  end

  # System Watering states
  WM_ACTIVE =  1
  WM_STANDBY = 0

  states = %w{ Standby Active }

  # Valve command values
  OFF = 0
  ON = 1
  
  # Sprinkle states
  IDLE = 0
  ACTIVE = 1
  NEXT = 2

  # Scheduling options
  CRONTAB_SPRINKLE_ALL  = 0
  CRONTAB_SPRINKLE_EACH = 1
  DAEMON_SPRINKLE_EACH  = 2

  CRONTAB = 'lib/assets/crontab'

  TIME_INPUT_STRFTIME = "%a %d %b %l:%M %P"

  LOGFILE = "log/water_manager_server.log"

  def log(msg)
    f = File.open(LOGFILE, 'a')
    f.write msg
    f.close
  end

  def water_manager_update(id)
    log "WaterManagerServer.water_manager_update(#{id})\n"
    wm = WaterManager.find(id)
    # toggle state
    wm.update(state: (wm.state == WM_ACTIVE ? WM_STANDBY : WM_ACTIVE))
    
    if wm.state == WM_ACTIVE
      log "wm.arm\n"
      arm
    else
      log "wm.disarm\n"
      disarm
    end
  end

  def scheduling_options
    %w{ CRONTAB_SPRINKLE_ALL CRONTAB_SPRINKLE_EACH DAEMON_SPRINKLE_EACH }[WaterManager.first.scheduling_option]
  end

  def arm
    log "Set up scheduling option: #{scheduling_options}\n"
    case WaterManager.first.scheduling_option
    when CRONTAB_SPRINKLE_ALL
      install_crontab
    when CRONTAB_SPRINKLE_EACH
      install_minute_hand_crontab
    when DAEMON_SPRINKLE_EACH
      install_scheduling_daemon
    end
  end

  def disarm
    # log "Removing crontab\n"
    remove_crontab
    Valve.all.each do |v|
      # close only those valves that are open.
      if v.cmd == ON
        v.command(OFF)
      end
    end
  end

  # HTTP_HOST=$3          localhost:nnnn
  # SPRINKLE_ID=$1        s.id
  # STATE=$2,             s.state
  def install_crontab
    # create a working crontab file
    # log "Building crontab\n"
    f = File.open(CRONTAB, 'w')
    f.write "MAIL='keburgett@gmail.com'\n"
    # f.write minute_hand_crontab_line
    # for each sprinkle, write a crontab entry for ON and OFF times.
    p = Porter.first.localhost_with_port # provides host:port combination
    sprinkle_agent_id = 99 # fUture update to use daemon, for now just a placeholder
    Sprinkle.all.each do |s|
      [ACTIVE, IDLE].each do |state| # Note that valve states and sprinkles states SHARE the same numeric values
        crontab_line =  "#{s.to_crontab_time(state)} sh #{s.actuator_path} #{p} #{s.to_crontab_attributes(state)}\n" 
        f.write crontab_line
        log "#{crontab_line}\n"
      end
    end
    f.close
    system("crontab #{CRONTAB}")
    log "crontab deployed\n"
    # Mark the first Sprinkle NEXT
    Sprinkle.first.update(state: NEXT)
  end

  def remove_crontab
    log "Removing crontab\n"
    system("crontab -r")
    system("touch lib/assets/crontab")
    system("rm lib/assets/crontab")
  end

  def install_minute_hand_crontab
    # log "Building crontab\n"
    f = File.open(CRONTAB, 'w')
    f.write "MAIL='keburgett@gmail.com'\n"
    f.write minute_hand_crontab_line
    f.close
  end

  def minute_hand_crontab_line
    "* * * * * sh /home/kenb/development/HyperAQ/lib/tasks/minute_hand_actuator.sh #{Porter.first.localhost_with_port} #{MinuteHand.first.id} #{WaterManager.first.key}\n"
  end

  def install_scheduling_daemon
  end

end 

