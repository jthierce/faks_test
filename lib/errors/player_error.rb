# frozen_string_literal: true

class PlayerError < StandardError
  def initialize(name, details = nil)
    message = "Player #{name} has a problem"
    message += ". #{details}" if details
    super(message)
  end
end
