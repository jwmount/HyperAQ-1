require 'models/valve'

class ValveButton < Hyperloop::Component
  param :valve_id

  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.

    @states = %w{ OFF ON }
    @colors = %w{ btn-primary btn-success }
  end

  def render
    valve = Valve.find(params.valve_id)
    LI do
      BUTTON(class: "btn #{state(valve)} navbar-btn") do
        A(href: '#', data: { toggle: "tooltip" }, title: "Valve #{valve.name } is #{state_name(valve)}") { valve.name }
      end.on(:click) {command(valve.id)}
    end
  end

  def command(valve_id)
    # signal the ServerOp to toggle the valve, and create or update a History (List)
    ManualValveServer.run(valve_id: valve_id)
  end

  def state(valve)
    @colors[valve.cmd]
  end

  def state_name(valve)
    @states[valve.cmd]
  end

end