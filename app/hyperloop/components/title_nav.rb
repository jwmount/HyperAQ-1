class TitleNav < Hyperloop::Component

  def render
    UL(class: 'navbar-header') do
      LI do
        A(class: 'navbar-brand', href: "#") do
          "HyperAQ: Aquarius Sprinkler System, with Hyperloop UI and crontab scheduling, now with tooltips!"
        end       
      end
    end
  end
end

