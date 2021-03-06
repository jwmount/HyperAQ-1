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
  DAEMON_MINUTE_HAND  = 1

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
    %w{ CRONTAB_SPRINKLE_ALL DAEMON_MINUTE_HAND }[WaterManager.first.scheduling_option]
  end

  def arm
    log "Set up scheduling option: #{scheduling_options}\n"
    case WaterManager.first.scheduling_option
    when CRONTAB_SPRINKLE_ALL
      install_crontab
    when DAEMON_MINUTE_HAND
      install_minute_hand_daemon
    end
  end

  def disarm
    log "Shut down scheduling option: #{scheduling_options}\n"
    case WaterManager.first.scheduling_option
    when CRONTAB_SPRINKLE_ALL
      remove_crontab
    when DAEMON_MINUTE_HAND
      remove_minute_hand_daemon
    end

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

  def actuator_path
    File.realdirpath('lib/tasks/minute_hand_daemon.rb')
  end

  SCALE_FACTOR = 1
  PID_FILE_NAME = 'tmp/pids/minute_hand_daemon.pid'

  def install_minute_hand_daemon
    spawnee = "ruby #{actuator_path} #{SCALE_FACTOR} #{Porter.first.localhost_with_port} #{WaterManager.first.key} #{File.realdirpath('lib/tasks/minute_hand_actuator.sh')}"
    log "spawn #{spawnee}\n"
    pid = Process.spawn(spawnee)
    f = File.open(PID_FILE_NAME, 'w')
    f.write pid.to_s
    log "#{PID_FILE_NAME}, pid --> #{pid}\n"
    f.close
  end

  def remove_minute_hand_daemon
    lines = File.readlines(PID_FILE_NAME)
    system("rm #{PID_FILE_NAME}")
    pid = lines[0].to_i
    system("kill -KILL #{pid}")
    log "kill pid #{pid}\n"
  end

end 

