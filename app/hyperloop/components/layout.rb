
  class Layout < Hyperloop::Component

    # Layout of everything on the page, except for the nav-bar.

    def render
      DIV(class: "container-fluid") do
        DIV(class: "row") do
          DIV(class: "col-sm-6") do
           SprinkleList {}
          end
          DIV(class: "col-sm-6") do
            HistoryList {}
          end
        end
      end
    end
  end

