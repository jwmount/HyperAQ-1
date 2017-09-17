require 'models/valve'

class ValveButtons < Hyperloop::Component

  before_mount do
    @valves = Valve.all
  end

  def render
    UL(class: 'nav navbar-nav navbar-right') do
      @valves.each do |valve|
        ValveButton(valve_id: valve.id)
      end
    end
  end
end



