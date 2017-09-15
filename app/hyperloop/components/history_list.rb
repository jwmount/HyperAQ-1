require 'models/list'
require 'models/valve'
require 'time'

class HistoryList < Hyperloop::Component
  
  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.
    
    mutate.count = List.count
  end
    
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
      @lists = List.all
      try_sort
      TBODY do
        @lists.each do |list| 
          HistoryRow(list: list)
        end
      end
    end
  end

  def try_sort
    if @lists.length != mutate.count
      mutate.count = @lists.length
      @lists.sort_by! {|h| h.start_time}
      @lists.reverse!
    end
    @lists
  end

end
