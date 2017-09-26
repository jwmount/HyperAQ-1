require 'models/sprinkle'

class SprinkleList < Hyperloop::Component

  render(DIV) do
    H4 { "Sprinkles"}

    TABLE(class: 'table') do
      THEAD do
        TR do
          TH { " Start Time " }          
          TH { " Time input " }
          TH { " Duration" }
          TH { " Valve " }
        end
      end
      TBODY do
        Sprinkle.all.each do |sprinkle|
          SprinkleRow(sprinkle: sprinkle)
        end
      end
    end  
  end
      
end