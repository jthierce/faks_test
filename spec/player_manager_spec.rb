# frozen_string_literal: true

require 'csv'
require_relative '../lib/player_manager'

describe PlayerManager do
  describe '.load_players' do
    let(:player_manager) { PlayerManager.new(data) }

    context 'with a array of data players' do
        let(:data) {
          [
            {'name' => 'Test1', 'age' => '23', 'elo' => '234'},
            {'name' => 'Test2', 'age' => '24', 'elo' => '434'},
            {'name' => 'Test3', 'age' => '25', 'elo' =>'334'}
          ]
        }
        let(:file_name) { 'basic_players.csv' }

      it 'return a array of instance player class' do
        expect(player_manager.load_players).to all(be_an_instance_of(Player))
      end
    end
  end
end