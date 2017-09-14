require 'models/valve'

class ValveButton < Hyperloop::Component
  param :valve_id

  def render
    valve = Valve.find(params.valve_id)
    LI do
      BUTTON(class: "btn #{state(valve)} navbar-btn") do
        valve.name
      end.on(:click) {command(valve.id)}
    end
  end

  def command(valve_id)
    # signal the ServerOp to toggle the valve, and create a History (List)
    ManualValveServer.run(valve_id: valve_id)
    # HistoryList.render()
  end

  def state(valve)
    valve.cmd == 0 ? "btn-primary" : 'btn-success'
  end

end