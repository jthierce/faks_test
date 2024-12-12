# frozen_string_literal: true

class Champions
  attr_reader :list

  def initialize(players)
    @players = players
    @list = extract_champions_from_players_list
  end

  def to_s
    return '' if @list.empty?

    format_champions = []
    format_champions << Player.attributes.join(', ')
    @list.each do |champion|
      format_champions << champion.fields.join(', ')
    end
    format_champions.join("\n")
  end

  private

  def extract_champions_from_players_list
    grouped_players = sort_and_group_players_by_age_and_elo
    extract_champions_from_grouped_players(grouped_players)
  end


  def sort_and_group_players_by_age_and_elo
    @players.sort_by! do |player|
      [player.age, -player.elo]
    end
    @players.group_by do |player|
      player.age
    end
  end

  def extract_champions_from_grouped_players(grouped_players)
    max_elo = 0
    champions_list = []

    grouped_players.each do |age, players_by_age|
      if players_by_age.first.elo > max_elo
        # Shifting the first element as it is never needed again; this provides a slight optimization.
        max_elo = players_by_age.first.elo
        champions_list << players_by_age.shift

        # This is useful when a player has the same elo and age, as it allows selecting them as a champion as well.
        players_by_age.each do |player|
          break if player.elo != max_elo
          champions_list << player
        end
      end
    end
    champions_list
  end
end
