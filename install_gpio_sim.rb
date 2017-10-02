# ruby install_gpio_sim.rb bin-folder
# This script 
File.symlink(File.realdirpath('lib/tasks/gpio_sim.sh'), "#{ARGV[0]}/gpio")