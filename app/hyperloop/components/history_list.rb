require 'models/list'
require 'models/valve'

class HistoryList < Hyperloop::Component
    
  render(DIV) do
    H4 { "Histories" }

    TABLE(class: 'table') do
      THEAD do
        TR do
          TH { " Start time " }
          TH { " Stop time " }
          TH { " Valve " }
        end
      end
      
      TBODY do
        List.all.each do |list| 
          HistoryRow(list: list)
        end
      end
    end
  end

end
