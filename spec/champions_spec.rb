# frozen_string_literal: true

require_relative '../lib/champions'
require_relative '../lib/player'

describe Champions do
  describe '.initialize' do
    context 'with a array of player' do
      let(:players) {
        [
          Player.new(name: 'Sebatien Toto', age: 28, elo: 1000),
          Player.new(name: 'Magnus Carlsen', age: 34, elo: 2882)
        ]
      }

      it 'return a instance of champions with data filled' do
        expect_any_instance_of(Champions).to receive(:extract_champions_from_players_list).and_call_original
        champions = Champions.new(players)
        expect(champions.list).to all(be_an_instance_of(Player))
      end
    end
  end

  describe '.to_s' do
    let(:champions) { Champions.new(players) }

    context 'when player does not have the same age or elo' do
      let(:players) {
        [
          Player.new(name: 'Sebatien Toto', age: 28, elo: 1000),
          Player.new(name: 'Magnus Carlsen', age: 34, elo: 2882),
          Player.new(name: 'Jhon Wick', age: 40, elo: 352),
          Player.new(name: 'Richard Rapport', age: 28, elo: 2721),
          Player.new(name: 'Aram Hakobyan', age: 23, elo: 2625),
          Player.new(name: 'Bad Player', age: 40, elo: 100),
          Player.new(name: 'Future Magnus', age: 14, elo: 2675),
          Player.new(name: 'Dimitri Rochard', age: 40, elo: 658)
        ]
      }

      it 'returns all correct champions' do
        expect(champions.to_s).to eq(<<~OUTPUT.strip
          name, age, elo
          Future Magnus, 14, 2675
          Richard Rapport, 28, 2721
          Magnus Carlsen, 34, 2882
          OUTPUT
        )
      end
    end

    context 'when players have the same ages but higher elo' do
      let(:players) {
        [
          Player.new(name: 'Magnus Carlsen', age: 34, elo: 2882),
          Player.new(name: 'Sebatien Toto', age: 34, elo: 1000)
        ]
      }

      it 'return the player with the higer elo' do
        expect(champions.to_s).to eq("name, age, elo\nMagnus Carlsen, 34, 2882")
      end
    end

    context 'when players have the same elo but one is younger' do
      let(:players) {
        [
          Player.new(name: 'Magnus Carlsen', age: 34, elo: 2882),
          Player.new(name: 'Sebatien Toto', age: 24, elo: 2882)
        ]
      }

      it 'return the player with the higer elo' do
        expect(champions.to_s).to eq("name, age, elo\nSebatien Toto, 24, 2882")
      end
    end

    context 'when no player is supplied' do
      let(:players) { [] }

      it 'return empty output' do
        expect(champions.to_s).to eq('')
      end
    end

    context 'when players have the same age and elo' do
      let(:players) {
        [
          Player.new(name: 'Magnus Carlsen', age: 24, elo: 2882),
          Player.new(name: 'Sebatien Toto', age: 24, elo: 2882)
        ]
      }

      it 'return all the tied players' do
        expect(champions.to_s).to eq(<<~OUTPUT.strip
          name, age, elo
          Magnus Carlsen, 24, 2882
          Sebatien Toto, 24, 2882
          OUTPUT
        )
      end
    end
  end
end