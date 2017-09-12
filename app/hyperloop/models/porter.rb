require 'models/application_record'
class Porter < ApplicationRecord
  # attr_reader :host_name
  # attr_reader :port_number

  def self.singleton
    Porter.first
  end
  
  def host_with_port
    "#{host_name}:#{port_number}"
  end

  def localhost_with_port
    "localhost:#{port_number}"
  end

  if RUBY_ENGINE != 'opal'
    LOGFILE = "log/porter.log"

    def self.log(msg)
      f = File.open(LOGFILE, 'a')
      f.write msg
      f.close
    end

  end

end
