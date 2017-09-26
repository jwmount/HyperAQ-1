class ManualValveServer < Hyperloop::ServerOp
  
  param :acting_user, nils: true
  param :valve_id
  dispatch_to { Hyperloop::Application }

  # Valve states
  OFF = 0
  ON = 1

  step do 
    manual_valve_update (params.valve_id)
  end
  
  #
  # manual valve update behavior
  #
  # All valve operations are toggles, so if a valve is ON, then a manual activation will turn it OFF.
  #
  def manual_valve_update(id)
    # fetch the valve instance
    valve = Valve.find(params.valve_id)

    # change state
    if valve.cmd == OFF
      valve.start
    else
      valve.stop
    end
  end

end 

