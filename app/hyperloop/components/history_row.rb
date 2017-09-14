require 'models/list'
require 'models/valve'

class HistoryRow < Hyperloop::Component
  param :list
    
  render do
    TR(class: markup) do
      
      TD { params.list.start_time_display }

      TD { params.list.stop_time_display }

      TD { params.list.valve.name }
      
    end
  end

  # change color as history state changes
  def markup
    params.list.stop_time_display == ' ' ? 'warning' : 'default'
  end

end
