require 'models/application_record'
class WaterManager < ApplicationRecord
  # Scheduling options
  # CRONTAB_SPRINKLE_ALL  = 0
  # DAEMON_MINUTE_HAND  = 1

  # CRONTAB_SPRINKLE_ALL  = 0
  # DAEMON_MINUTE_HAND  = 1

  def self.scheduler
    %w{ crontab_all daemon_minute_hand }[WaterManager.first.scheduling_option]
  end

  def self.scheduling_options
    %w{ CRONTAB_SPRINKLE_ALL DAEMON_MINUTE_HAND }[WaterManager.first.scheduling_option]
  end


end 
