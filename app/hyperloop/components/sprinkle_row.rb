require 'models/sprinkle'
require 'models/valve'

class SprinkleRow < Hyperloop::Component
  param :sprinkle
    
  # Sprinkle states
  IDLE = 0
  ACTIVE = 1
  NEXT = 2

  render do
    TR(class: markup) do
      TD { params.sprinkle.start_time_display }
    
      TD { params.sprinkle.time_input }    
    
      TD { params.sprinkle.duration.to_s }
    
      TD { params.sprinkle.valve.name }
    end
  end

  # change color as sprinkle state changes
  def markup
    #   IDLE    ACTIVE NEXT
    %w{ default info   danger }[params.sprinkle.state]
  end

end