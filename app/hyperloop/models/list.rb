require 'models/application_record'
class List < ApplicationRecord

  belongs_to :valve

  SECONDS_PER_HOUR = 60*60
  SECONDS_PER_DAY = 24*SECONDS_PER_HOUR
  SECONDS_PER_WEEK = SECONDS_PER_DAY * 7
  PRUNE_INTERVAL = 1 * SECONDS_PER_WEEK 

  # Create an instance of History, using valve_id of the owning Valve as initialization parameter
  def self.start(valve)
    List.create(start_time: Time.now, start_time_display: Time.now.strftime("%a %d %b %l:%M %P"), stop_time_display: ' ', valve_id: valve.id)
  end

  # Complete the history
  def stop
    update(stop_time_display: Time.now.strftime("%a %d %b %l:%M %P"))
  end

  # Delete entries older than Time.now - PRUNE_INTERVAL
  def self.prune
    List.all.each do |list|
      if list.start_time < Time.now - PRUNE_INTERVAL
        list.delete
      end
    end
  end
end
