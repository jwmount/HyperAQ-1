require 'models/list'
require 'models/valve'

class HistoryRow < Hyperloop::Component
  param :list
    
  HISTORY_TIME_FORMAT = "%a %d %b %l:%M:%S %P"    

  render do
    TR(class: markup) do
      
      TD { params.list.start_time.strftime(HISTORY_TIME_FORMAT) }

      TD { stop_time_display }

      TD { params.list.valve.name }
      
    end
  end

  # change color as history state changes
  def markup
    params.list.stop_time.nil? ? 'warning' : 'default'
  end

  # handle nil case
  def stop_time_display
    params.list.stop_time.nil? ? ' ' : params.list.stop_time.strftime(HISTORY_TIME_FORMAT)
  end
  
end
