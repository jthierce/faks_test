# frozen_string_literal: true

require_relative '../lib/champions'
require_relative '../lib/player_manager'
require_relative '../lib/helpers/csv_helper'


describe Champions do
  let(:players_file_path) { 'players_files' }
  let(:fixtures_file_path) { 'spec/fixtures/results' }

  describe '.list' do
    let(:csv) { CsvHelper.read("#{players_file_path}/#{file_name}") }
    let(:player_manager) { PlayerManager.new(csv) }
    let(:file) { File.open("#{fixtures_file_path}/#{file_name}") }
    let(:champions) {Champions.new(player_manager.players) }

    before :each do
      player_manager.load_players
    end

    context 'when player does not have the same age or elo' do
      let(:file_name) { 'basic_players.csv' }

      it 'returns all correct champions' do
        expect(champions.to_s).to eq(file.read)
      end
    end

    context 'when players have the same ages but higher elo' do
      let(:file_name) { 'same_age_but_higher_elo.csv' }

      it 'return the player with the higer elo' do
        expect(champions.to_s).to eq(file.read)
      end
    end

    context 'when players have the same elo but one is younger' do
      let(:file_name) { 'same_elo_but_younger_player.csv' }

      it 'return the player with the higer elo' do
        expect(champions.to_s).to eq(file.read)
      end
    end

    context 'when we have no players' do
      let(:file_name) { 'empty_players.csv' }

      it 'return empty output' do
        expect(champions.to_s).to eq('')
      end
    end

    context 'when players have the same age and elo' do
      let(:file_name) { 'tied_player.csv' }

      it 'return all the thied players' do
        expect(champions.to_s).to eq(file.read)
      end
    end
  end
end