class WaterStatus < Hyperloop::Component
    
  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.

    @states = %w{ Standby Active }
    @colors = %w{ btn-info btn-warning }
    @singleton = WaterManager.first
  end

  def system_state
    @states[@singleton.state]
  end

  def toggle_system_state
    # call to ServerOp which changes the server state in accordance with the state variable
    WaterManagerServer.run(wm_id: @singleton.id)
  end

  def system_button_color
    @colors[@singleton.state]
  end

  def render
    title = "System is in #{system_state} mode"
    UL(class: 'nav navbar-nav')  do
      LI do
        BUTTON(class: "btn #{system_button_color} navbar-btn", data: { toggle: "tooltip" }, title: title) do 
          system_state
        end.on(:click) { toggle_system_state }
      end
    end
  end

end

