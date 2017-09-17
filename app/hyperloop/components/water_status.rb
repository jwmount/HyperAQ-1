class WaterStatus < Hyperloop::Component
    
  # STANDBY = 0
  # ACTIVE = 1

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
    UL(class: 'nav navbar-nav')  do
      LI do
        BUTTON(class: "btn #{system_button_color} navbar-btn") do 
          A(href: '#', data: { toggle: "tooltip" }, title: "System is in #{system_state} mode") { system_state }
        end.on(:click) { toggle_system_state }
      end
    end
  end

end

