# frozen_string_literal: true

require_relative 'player'
require_relative 'champions'

class PlayerManager
  attr_reader :players, :champions

  def initialize(data)
    @data = data
    @players = []
    @sorted_players = []
  end

  # Loads player data and initializes Player objects
  def load_players
    @players = @data.map do |raw_player|
      Player.new(age: raw_player['age'], elo: raw_player['elo'], name: raw_player['name'])
    end
  end

  # Returns the instance champions
  def champions
    @champions ||= Champions.new(@players)
  end
end
