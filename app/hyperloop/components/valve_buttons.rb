require 'models/valve'

class ValveButtons < Hyperloop::Component

  def render
    UL(class: 'nav navbar-nav navbar-right') do
      Valve.all.each do |valve|
        ValveButton(valve: valve)
      end
    end
  end
end
