require 'models/list'
require 'models/valve'
require 'time'

class HistoryRow < Hyperloop::Component
  param :list
    
  HISTORY_TIME_FORMAT = "%a %d %b %l:%M %P"    

  render do
    TR(class: markup) do
      
      TD { params.list.start_time.strftime("%a %d %b %l:%M %P") }

      TD { stop_time_display }

      TD { params.list.valve.name }
      
    end
  end

  # change color as history state changes
  def markup
    params.list.stop_time.nil? ? 'warning' : 'default'
  end

  def stop_time_display
    params.list.stop_time.nil? ? ' ' : params.list.stop_time.strftime("%a %d %b %l:%M %P")
  end
  
end
