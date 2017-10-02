#/app/hyperloop/components/navbar.rb

class Navbar < Hyperloop::Component
  render(NAV) do
    NAV(class: 'navbar navbar-default') do
      DIV(class: 'container-fluid') do
        PorterStatus {}
        WaterStatus {}
        ScaleForm {}
        TitleNav {}
        ValveButtons {}
      end
    end
  end

end
