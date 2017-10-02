#
# Invocation
# ruby minute_hand_daemon.rb scale_factor host_with_port key actuator_path
#
# require 'rest-client'
# require 'net/http'
require 'json'

LOGFILE = "/home/kenb/development/HyperAQ/log/minute_hand_daemon.log"
LOG_TIME = "%H:%M:%S"

def log_time
  Time.now.strftime(LOG_TIME)
end

def log(msg)
  f = File.open(LOGFILE, 'a')
  f.write msg
  # f.write "#{log_time} #{msg}"
  f.close
end

class MinuteHandDaemon
  def initialize(argv)
    @scale_factor = argv[0].to_i
    log "scale_factor --> #{@scale_factor}\n"
    @host_with_port = argv[1]
    log "host_with_port #{@host_with_port}\n"
    @key = argv[2]
    log "key #{@key}\n"
    @actuator_path = argv[3]
    log "actuator_path --> #{actuator_path}\n"
  end

  def host_with_port
    @host_with_port
  end

  def scale_factor
    @scale_factor
  end

  def seconds_between_requests
    60/scale_factor
  end

  def auth_key
    @key
  end

  def actuator_path
    @actuator_path
  end

  def tick_request
    payload = "sh #{actuator_path} #{host_with_port} 1 #{auth_key}"
    # log "tick --> #{payload}\n"
    system(payload)
  end

  def tick_loop
    # synch to scaled "whole minute" boundary
    # puts Time.now.sec
    while Time.now.sec != 0
      sleep(1)
    end
    # Time.now.sec
    # puts Time.now
    # send 1 tick per minute, appropriately scaled
    while true
      sleep(seconds_between_requests)
      tick_request
    end
  end
end

MinuteHandDaemon.new(ARGV).tick_loop

