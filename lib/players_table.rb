# frozen_string_literal: true

require_relative '../config/variables'

class PlayersTableError < StandardError; end

# changer le nom en PlayerTable
class PlayersTable
  INTEGER_HEADERS = %w[age elo].freeze

  attr_reader :players, :champions

  # Initializes PlayersTable to validate if there are any invalid data in the CSV,
  # transforms specific columns into integers, sorts the players first by age and then by ELO,
  # and groups them by age to create an array that is easy to use for finding champions.
  # the method is speed because is
  def initialize(args)
    @players = args[:csv]
    @champions = []
    verify_and_transform_data
    sort_and_group_players_by_age_and_elo
  end

  def find_champions
    max_elo = 0

    @players.each do |age, players_by_age|
      if players_by_age.first['elo'] > max_elo
        # Shifting the first element as it is never needed again; this provides a slight optimization.
        max_elo = players_by_age.first['elo']
        @champions << players_by_age.shift

        # This is useful when a player has the same elo and age, as it allows selecting them as a champion as well.
        players_by_age.each do |player|
          break if player['elo'] != max_elo
          @champions << player
        end
      end
    end
    @champions
  end

  def display_champions
    return '' if @champions.empty?

    format_champions = []
    format_champions << @champions.first.headers.join(', ')
    @champions.each do |champion|
      format_champions << champion.fields.join(', ')
    end
    format_champions.join("\n")
  end

  private

  def validate_player(player)
    validate_age(player)
    validate_elo(player)
  end
  
  # Verify that the participant is not too young or too old.
  def validate_age(player)
    if player['age'] > Config::Variables::MAX_AGE || player['age'] < Config::Variables::MIN_AGE
      warn "Player #{player['name']} has an invalid age"
      raise PlayersTableError.new('Invalid age')
    end
  end
  
  # Verify that the participant does not have an invalid elo.
  def validate_elo(player)
    if player['elo'] < Config::Variables::MINIMUM_ELO
      warn "Player #{player['name']} has an invalid elo. (Too low)"
      raise PlayersTableError.new('Invalid elo')
    end
  end

  # Validates that all mandatory headers are present in the CSV.
  def validate_headers
    missing_headers = Config::Variables::MANDATORY_HEADERS.reject do |header|
      @players.headers.include?(header)
    end
    unless missing_headers.empty?
      warn "Missing headers: #{missing_headers.join(', ')}"
      raise PlayersTableError.new("Missing headers: #{missing_headers.join(', ')}")
    end
  end

  # Validates headers, transforms integer columns, and verifies player data (age, elo).
  def verify_and_transform_data
    validate_headers

    @players = @players.map do |player|
      player = transform_integer_column(player)
      validate_player(player)
      player
    end
  end

  def transform_integer_column(player)
    INTEGER_HEADERS.each do |integer_header|
      player[integer_header] = Integer(player[integer_header])
    rescue StandardError => _e
      warn "Player #{player['name']} has an invalid data in #{integer_header}"
      raise PlayersTableError.new("Invalid data in #{integer_header}")
    end
    player
  end

  def sort_and_group_players_by_age_and_elo
    @players.sort_by! do |player|
      [player['age'], -player['elo']]
    end
    @players = @players.group_by do |player|
      player['age']
    end
  end
end