require 'models/valve'

class ValveButton < Hyperloop::Component
  param :valve

  def render
    LI do
      BUTTON(class: "btn #{state(params.valve)} navbar-btn") do
        params.valve.name
      end.on(:click) {command(params.valve)}
    end
  end

  def command(valve)
    # signal the ServerOp to toggle the valve, and create a History (List)
    ManualValveServer.run(valve_id: valve.id)
    # HistoryList.render()
  end

  def state(valve)
    valve.cmd == 0 ? "btn-primary" : 'btn-success'
  end

end