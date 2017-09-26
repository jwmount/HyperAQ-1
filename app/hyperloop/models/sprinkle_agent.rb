require 'models/application_record'
class SprinkleAgent < ApplicationRecord
	has_one :sprinkle

  if RUBY_ENGINE != 'opal'
  end # RUBY_ENGINE

end
