require 'models/sprinkle'
require 'models/valve'

class SprinkleRow < Hyperloop::Component
  param :sprinkle

  render do
    TR(class: markup) do
      TD { params.sprinkle.next_start_time_display }
    
      TD { params.sprinkle.time_input }    
    
      TD { params.sprinkle.duration.to_s }
    
      TD { params.sprinkle.valve.name }
    end
  end

  # change color as sprinkle state changes
  def markup
    %w{default danger info}[params.sprinkle.state]
  end

end