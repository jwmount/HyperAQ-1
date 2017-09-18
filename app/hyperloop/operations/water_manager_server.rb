class WaterManagerServer < Hyperloop::ServerOp
  param :acting_user, nils: true
  param :wm_id #, type: Number
  dispatch_to { Hyperloop::Application }

  # Sprinkle states
  IDLE = 0
  NEXT = 1
  ACTIVE = 2

  # System Watering states
  ACTIVE =  1
  STANDBY = 0

  states = %w{ Standby Active }

  # Valve command values
  OPEN = 1
  CLOSE = 0

  CRONTAB = 'lib/assets/crontab'

  TIME_INPUT_STRFTIME = "%a %d %b %l:%M %P"

  LOGFILE = "log/crontab.log"

  def log(msg)
    f = File.open(LOGFILE, 'a')
    f.write msg
    f.close
  end

  step do 
    water_manager_update(params.wm_id)
  end

  def water_manager_update(id)
    log "WaterManagerServer.water_manager_update(#{id})\n"
    wm = WaterManager.first
    # change state
    wm.update(state: (wm.state == ACTIVE ? STANDBY : ACTIVE))
    
    if wm.state == ACTIVE
      log "wm.arm\n"
      arm
    else
      log "wm.disarm\n"
      disarm
    end
  end

  def arm
    # log "Installing crontab\n"
    install_crontab
  end

  def disarm
    # log "Removing crontab\n"
    remove_crontab
    Valve.all.each do |v|
      # close only those valves that are open.
      if v.cmd == OPEN
        v.command(CLOSE)
      end
    end
  end

  # minute (0-59), hour (0-23, 0 = midnight), day (1-31), month (1-12), weekday (0-6, 0 = Sunday), command(valve_id, on/off, host:port, sprinkle)
  # 03 19 * * 2 sh /home/kenb/development/Aquarius/lib/tasks/valve_actuator.sh  v_id cmd hp s_id

  # where

  # VALVE_ID=$1,    v_id
  # CMD=$2,         cmd
  # HTTP_HOST=$3    localhost:nnnn
  # SPRINKLE_ID=$4  s_id
  def install_crontab
    # create a working crontab file
    log "Building crontab\n"
    f = File.open(CRONTAB, 'w')
    f.write "MAIL='keburgett@gmail.com'\n"
    # for each sprinkle, write a crontab entry for OPEN and CLOSE times.
    p = Porter.first.localhost_with_port # provides host:port combination
    Sprinkle.all.each do |s|
      [OPEN, CLOSE].each do |action|
        crontab_line =  "#{s.to_crontab(action)} sh #{valve_actuator_path} #{s.valve.to_crontab(action)} #{p} #{s.id}\n" 
        f.write crontab_line
        # log "#{crontab_line}\n"
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

  def valve_actuator_path
    File.realdirpath('lib/tasks/valve_actuator.sh')
  end

end 

