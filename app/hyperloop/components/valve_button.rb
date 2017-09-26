require 'models/valve'

class ValveButton < Hyperloop::Component
  param :valve

  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.

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

  def command
    # signal the ServerOp to toggle the valve, and create or update a History (List)
    ManualValveServer.run(valve_id: params.valve.id)
  end

  def color
    @colors[params.valve.cmd]
  end

  def state
    @states[params.valve.cmd]
  end

end