# frozen_string_literal: true

require_relative 'errors/player_error'
require_relative '../config/variables'

class Player
  attr_accessor :name, :age, :elo

  def initialize(name:, age:, elo:)
    @name = name
    self.age = age
    self.elo = elo
  end

  def fields
    [name, age, elo]
  end

  def self.attributes
    [:name, :age, :elo]
  end

  private

  def age= value
    begin
      @age = Integer(value)
    rescue StandardError => exception
      raise PlayerError.new(name, "Invalid data in age")
    end

    if @age > Config::Variables::MAX_AGE || age < Config::Variables::MIN_AGE
      raise PlayerError.new(name, 'Invalid age')
    end
  end

  def elo= value
    begin
      @elo = Integer(value)
    rescue StandardError => exception
      raise PlayerError.new(name, "Invalid data in elo")
    end

    if @elo < Config::Variables::MIN_ELO
      raise PlayerError.new(name, 'Invalid elo')
    end
  end
end
