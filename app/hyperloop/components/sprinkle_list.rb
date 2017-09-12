require 'models/sprinkle'

class SprinkleList < Hyperloop::Component


  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.
    
    @sprinkles = Sprinkle.all
    @next_start_time = Time.now
  end

  render(DIV) do
    H4 { "Sprinkles"}

    TABLE(class: 'table') do
      THEAD do
        TR do
          # TH { " State "}
          TH { " Next Start Time " }          
          TH { " Time input " }
          TH { " Duration" }
          TH { " Valve " }
        end
      end
      try_sort
      TBODY do
        @sprinkles.each do |sprinkle|
          SprinkleRow(sprinkle: sprinkle)
        end
        mark_next
      end
    end  
  end
 
  # Sprinkle states
  IDLE = 0
  NEXT = 1
  ACTIVE = 2

  def mark_next
    # Set the status of the first sprinkle in the list to 'Next'
    s = Sprinkle.first
    if s.state != ACTIVE
      s.state = NEXT
      s.save
    end
  end

  def try_sort
    if @next_start_time != @sprinkles[0].next_start_time
      @sprinkles.sort_by! {|s| s.next_start_time}
      @next_start_time = @sprinkles[0].next_start_time
    end
  end
      
end