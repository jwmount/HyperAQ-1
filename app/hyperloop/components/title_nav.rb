class TitleNav < Hyperloop::Component

  def render
    UL(class: 'navbar-header') do
      LI do
        A(class: 'navbar-brand', href: "#") do
          advertisement
        end       
      end
    end
  end

  def advertisement
    "HyperAQ: Aquarius Sprinkler System, with Hyperloop UI, #{scheduler} scheduling, now with tooltips!"
  end

  # CRONTAB_SPRINKLE_ALL  = 0
  # DAEMON_MINUTE_HAND  = 1

  def scheduler
    %w{ crontab_all daemon_minute_hand }[WaterManager.first.scheduling_option]
  end

end

