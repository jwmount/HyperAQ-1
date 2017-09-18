require 'time'

# Valve definitions
#
IDLE = 0
NEXT = 1
ACTIVE = 2

TIME_INPUT_STRFTIME = "%a %d %b %l:%M %P"

# Common CAT 6 power: orange-brown
# Common cord power: black

# create the top-level WaterManager.singleton
WaterManager.create(state: 'Standby')
#
# create the Porter singleton, with dummy data
#
Porter.create(host_name: 'did-not-work', port_number: 9999)
#
# remove unused fields, keep for documentation here.
#
# atrium = Valve.create(name: 'Atrium', gpio_pin: 7, cmd:0, bb_pin: 27, cpu2bb_color: 'red',         relay_module: 2, relay_index: 1)
# back   = Valve.create(name: 'Back',   gpio_pin:22, cmd:0, bb_pin: 22, cpu2bb_color: 'cream',       relay_module: 1, relay_index: 4)
# deck   = Valve.create(name: 'Deck',   gpio_pin:12, cmd:0, bb_pin: 12, cpu2bb_color: 'brown',       relay_module: 1, relay_index: 1)
# front  = Valve.create(name: 'Front',  gpio_pin:16, cmd:0, bb_pin: 18, cpu2bb_color: 'white-brown', relay_module: 1, relay_index: 3)
# tomato = Valve.create(name: 'Tomato', gpio_pin:18, cmd:0, bb_pin: 16, cpu2bb_color: 'orange',      relay_module: 1, relay_index: 2)

atrium = Valve.create(name: 'Atrium', gpio_pin: 7, cmd:0, active_sprinkle_id: 0, active_history_id: 0)
back   = Valve.create(name: 'Back',   gpio_pin:22, cmd:0, active_sprinkle_id: 0, active_history_id: 0)
deck   = Valve.create(name: 'Deck',   gpio_pin:12, cmd:0, active_sprinkle_id: 0, active_history_id: 0)
front  = Valve.create(name: 'Front',  gpio_pin:16, cmd:0, active_sprinkle_id: 0, active_history_id: 0)
tomato = Valve.create(name: 'Tomato', gpio_pin:18, cmd:0, active_sprinkle_id: 0, active_history_id: 0)

# production sprinkle set; keep updated as watering needs evolve.
# ****************************** uncomment below for production sprinkle set ****************
hour = 7
%w{ Sun Mon Tue Wed Thu Fri Sat }.each do |day|
  %w{am pm}.each do |meridian|
    s = Sprinkle.create( time_input: "#{day} #{hour}:00 #{meridian}" , duration:  3, valve_id: atrium.id, state: IDLE) #unless meridian == 12
    s.update(next_start_time: s.start_time, next_start_time_display: s.start_time.strftime(TIME_INPUT_STRFTIME))
    s = Sprinkle.create( time_input: "#{day} #{hour}:05 #{meridian}" , duration:  3, valve_id: back.id, state: IDLE)
    s.update(next_start_time: s.start_time, next_start_time_display: s.start_time.strftime(TIME_INPUT_STRFTIME))
    s = Sprinkle.create( time_input: "#{day} #{hour}:10 #{meridian}" , duration:  3, valve_id: deck.id, state: IDLE) unless meridian == 12
    s.update(next_start_time: s.start_time, next_start_time_display: s.start_time.strftime(TIME_INPUT_STRFTIME)) unless meridian == 12
    s = Sprinkle.create( time_input: "#{day} #{hour}:15 #{meridian}" , duration:  3, valve_id: front.id, state: IDLE) #unless meridian == 12
    s.update(next_start_time: s.start_time, next_start_time_display: s.start_time.strftime(TIME_INPUT_STRFTIME))
    s = Sprinkle.create( time_input: "#{day} #{hour}:20 #{meridian}" , duration:  5, valve_id: tomato.id, state: IDLE)
    s.update(next_start_time: s.start_time, next_start_time_display: s.start_time.strftime(TIME_INPUT_STRFTIME))
  end
end
# ****************************** uncomment above for production sprinkle set ****************


# use this method to answer a time_input string based on current time + a delay in minutes
def seed_time(delay)
  (Time.now + delay*60).strftime("%a %I:%M %P")
end

# testing sprinkle set; quick test of all 5 valves in 20 minutes
# Sprinkle.create( time_input: seed_time(ix) , duration: 1, valve_id: 1 )
# ****************************** uncomment below for test sprinkle set ****************
# ix = 2 # start first sprinkle 2 minutes from now.
# 2.times.each do
#   Valve.all.each do |valve|
#     s = Sprinkle.create( time_input: seed_time(ix) , duration: 1, valve_id: valve.id, state: IDLE )
#     st = s.start_time
#     s.update( next_start_time: st, next_start_time_display: st.strftime(TIME_INPUT_STRFTIME) )
#     ix += 2
#   end
# end
# ****************************** uncomment above for test sprinkle set ****************


# minimal system test, fire atrium for one minute after 5 minute delay
#Sprinkle.create( time_input: seed_time(5), duration: 1, valve_id: atrium.id)

# Test Histories
# ix = Time.now
# 2.times.each do
#   Valve.all.each do |valve|
#     List.create(valve_id: valve.id, start_time: ix, stop_time: ix + 5*60)
#     ix = ix + 6*60
#   end
# end

