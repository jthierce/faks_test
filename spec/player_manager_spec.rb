# frozen_string_literal: true

require 'csv'
require_relative '../lib/player_manager'

describe PlayerManager do
  let(:players_file_path) { 'players_files' }

  describe 'load_players' do
    let(:csv) { CSV.read("#{players_file_path}/#{file_name}", headers: true, header_converters: :downcase) }
    let(:player_manager) { PlayerManager.new(csv) }

    context 'input is a csv player' do
        let(:file_name) { 'basic_players.csv' }

      it 'return a array of instance player class' do
        expect(player_manager.load_players).to all(be_an_instance_of(Player))
      end
    end
  end
end