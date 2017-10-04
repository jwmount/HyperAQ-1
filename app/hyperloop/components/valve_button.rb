require 'models/valve'

class ValveButton < Hyperloop::Component
  param :valve

  def render
    LI do
      title = "Valve #{params.valve.name} is #{state}"
      BUTTON(class: "btn #{color} navbar-btn", data: { toggle: "tooltip"  }, title: title) do
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
    %w{ btn-primary btn-success }[params.valve.cmd]
  end

  # defines text state for tooltip title
  def state
    %w{ OFF ON }[params.valve.cmd]
  end

end 