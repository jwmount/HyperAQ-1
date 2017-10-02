#
# SprinkleDaemon, a time scheduler for a single Sprinkle sequence. One of these is launched for every Sprinkle event.
#
# ruby lib/tasks/sprinkle_daemon.rb sprinkle_id start_time duration key hostname:port sprinkle_agent_id # convert to json string as single param
#
# 1.  Read params: sprinkle_id, start_time, duration, key, hostname:port, sprinkle_agent_id as json string
# 2.  Sleep until the start_time
# 3.  Issue a start request, specifying sprinkle_id, start_command, key
# 4.  Sleep until the stop_time (start_time + duration)
# 5.  Issue a stop request, specifying sprinkle_id, stop_command, key
# 6.  Exit

require 'rubygems'
require 'rest_client'
require 'json'

FORMAT = "%a %d %b %l:%M %P"

class SprinkleDaemon
  def initialize(jdata)
    @hash = JSON.parse(jdata)
    # replace the following with a JSON.parse of ARGV[0]
    # do #1 above, stash in instance variables.
    # @hash = JSON.parse ARGV[0]
    puts @hash
    puts "@hash['sprinkle_id'] --> #{@hash['sprinkle_id']}"
    @sprinkle_id = @hash['sprinkle_id']
    puts "@sprinkle_id --> #{@sprinkle_id}"
    @start_time = Time.new(@hash['start_time'])
    puts "@start_time --> #{@start_time.strftime(FORMAT)}"
    @duration = @hash["duration"]
    puts "@duration --> #{@duration}"
    @stop_time = @start_time + @duration.to_i*60
    puts "@stop_time --> #{@stop_time.strftime(FORMAT)}"
    @key = @hash['key'] # a random number that matches 'key' in the sprinkle
    puts "@key --> #{@key}"
    @host_with_port = @hash['host_with_port']
    puts "@host_with_port --> #{@host_with_port}"
    @sprinkle_agent_id = @hash['sprinkle_agent_id']
    puts "@sprinkle_agent_id --> #{@sprinkle_agent_id}"
  end

  # make an http request
  def request(state)
    case state

    when :start
      puts 'got to request, case "start"'
      jdata = JSON.generate({sprinkle_agent_id: @sprinkle_agent_id, state: 1, key: @key})
      puts "jdata --> #{jdata}"
      RestClient.put "http://#{@host_with_port}/sprinkles/1", jdata, {:content_type => :json}

    when :stop
      jdata = JSON.generate({sprinkle_id: @sprinkle_id, state: 'stop', key: @key})
      puts "jdata --> #{jdata}"
      # RestClient.put "http://#{@host_with_port}/sprinkle_agents/1", jdata, {:content_type => :json}
    end
  end

  def start
    # do #2 above
    # sleep(@start_time - Time.now)
    # do #3 above
    request(:start)
  end

  def stop
    # do #4 above
    sleep(@stop_time - Time.now)
    # do #5 above
    request(:stop)
  end
end

hash = 
{
  key: 'kkk', 
  command: 1, 
  sprinkle_id: 2, 
  start_time: Time.now + 15, 
  duration: 1, 
  host_with_port: "localhost:3000",
  sprinkle_agent_id: 2
}

jdata = JSON.generate(hash)
daemon = SprinkleDaemon.new(jdata)
daemon.start
# daemon.stop
#
# do #6 above
#
# All done.  So long and thanks for all the fish.
#

# jdata = JSON.generate({sprinkle_id: 99, command: 'start', key: 'kkk'})
# puts jdata
# hash = JSON.parse jdata
# puts hash

# {sprinkle_id: 99, "command"=>"start", "key"=>"kkk"}


# ruby sprinkle_daemon.rb "{\"sprinkle_id\":99,\"command\":\"start\",\"key\":\"kkk\"}"
