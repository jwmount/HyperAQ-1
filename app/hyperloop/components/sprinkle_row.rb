require 'models/sprinkle'
require 'models/valve'
require 'time'

class SprinkleRow < Hyperloop::Component
  param :sprinkle

  TIME_DISPLAY_STRFTIME = "%a %d %b %l:%M %P"

  render do
    TR(class: markup) do
      TD { params.sprinkle.next_start_time_display }
    
      TD { params.sprinkle.time_input }    
    
      TD { params.sprinkle.duration.to_s }
    
      TD { params.sprinkle.valve.name }
    end
  end

  def markup
    %w{default danger info}[params.sprinkle.state]
  end

end