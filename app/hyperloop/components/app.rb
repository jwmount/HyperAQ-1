# App was Component,
  class App < Hyperloop::Component
# Now App is a router, works either way
#  class App < Hyperloop::Component

    # The top of the component tree.
    def render 
      UL do
        Navbar {}
        Layout {}
      end
      # .while_loading do # while loading displays while waiting for hyperloop to load data from server!
      #   DIV { "loading..." } # or whatever you want in here
      # end
    end
  
  end
