require 'models/valve'

class ValveButton < Hyperloop::Component
  param :valve

  before_mount do
    @states = %w{ OFF ON }
    @colors = %w{ btn-primary btn-success }
  end

  def render
    LI do
      title = "Valve #{params.valve.name} is #{state}"
      BUTTON(class: "btn #{color} navbar-btn", data: { toggle: "tooltip" , placement: 'bottom' }, title: title) do
        params.valve.name 
      end.on(:click) {command}
    end
  end

  # signal the ServerOp(ManualValveServer) to toggle the valve, and create or update a History (List)
  def command
    ManualValveServer.run(valve_id: params.valve.id)
  end

  # defines background color the button in OFF/ON states
  def color
    @colors[params.valve.cmd]
  end

  # defines text state for tooltip title
  def state
    @states[params.valve.cmd]
  end

end 