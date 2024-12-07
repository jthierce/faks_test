# frozen_string_literal: true

require_relative '../config/variables'

# changer le nom en PlayerTable
class PlayersTable
  INTEGER_HEADERS = %w[age elo].freeze

  attr_reader :players

  def initialize(args)
    @players = args[:csv]
    verify_and_transform_data
    group_by_age_sort_by_elo
  end

  def find_champions
    max_elo = 0
    champions = []

    @players.each do |age, players_by_age|
      current_age = age
      if players_by_age.first['elo'] > max_elo
        max_elo = players_by_age.first['elo']
        champions << players_by_age.shift
      end
      players_by_age.each do |player|
        break if player['elo'] != max_elo
        champions << player
      end
    end
    champions
  end

  private

  def verify_and_transform_data
    headers_valid = Config::Variables::MANDATORY_HEADERS.all? do |mandatory_header|
      @players.first.headers.include?(mandatory_header)
    end
    unless headers_valid
      warn 'Invalid headers'
      raise CSV::MalformedCSVError.new('Invalid headers')
    end

    @players = @players.map do |player|
      player = transform_integer_column(player)

      if player['age'] > Config::Variables::OLDER_AGE || player['age'] < Config::Variables::YOUNGEST_AGE
        warn "Player #{player['name']} has an invalid age"
        raise CSV::MalformedCSVError.new('Invalid age')
      end

      if player['elo'] < Config::Variables::MINIMUM_ELO
        warn "Player #{player['name']} has an invalid elo. (Too low)"
        raise CSV::MalformedCSVError.new('Invalid elo')
      end
      player
    end
  end

  def transform_integer_column(player)
    INTEGER_HEADERS.each do |integer_header|
      player[integer_header] = Integer(player[integer_header])
    rescue ArgumentError => _e
      warn "Player #{player['name']} has an invald data in #{integer_header}"
      raise CSV::MalformedCSVError.new("Invalid data in #{integer_header}")
    end
    player
  end

  def group_by_age_sort_by_elo
    @players.sort_by! do |player|
      [player['age'], -player['elo']]
    end
    @players = @players.group_by do |player|
      player['age']
    end
  end
end