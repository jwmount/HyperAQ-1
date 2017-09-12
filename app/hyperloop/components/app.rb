
  class App < Hyperloop::Component

    # The top of the component tree.

    def render
      UL do
        Navbar {}
        Layout {}
      end
    end
  end

