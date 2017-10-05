# config/initializers/hyperloop.rb
# If you are not using ActionCable, see http://ruby-hyperloop.io/docs/models/configuring-transport/
Hyperloop.configuration do |config|
  config.transport = :action_cable
  config.import 'reactrb/auto-import'
  config.prerendering = :off
end

Hyperloop.class_eval do
  def self.on_server?
    Rails.const_defined?('Server') || (Rails.const_defined?('Puma') && File.basename($0).present? && File.basename($0).include?('puma'))
  end
end
