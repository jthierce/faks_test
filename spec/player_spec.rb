# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  describe 'new' do
    context 'create a player with correct data' do
      it 'return a player instance with all data specified' do
        player = Player.new(name: 'toto', age: '24', elo: '123')
        expect(player.fields).to eq(['toto', 24, 123])
      end
    end

    context 'create a player with invalid age' do
      it 'raises a PlayerError with a message indicating invalid data for age' do
        expect { Player.new(name: 'toto', age: '2rr', elo: '244') }.to raise_error(PlayerError) do |e|
          expect(e.message).to eq('Player toto has a problem. Invalid data in age')
        end
      end
    end

    context 'create a player with an age that is too young' do
      it 'raises a PlayerError with a message indicating the age is invalid' do
        expect { Player.new(name: 'toto', age: '1', elo: '244') }.to raise_error(PlayerError) do |e|
          expect(e.message).to eq('Player toto has a problem. Invalid age')
        end
      end
    end
    
    context 'create a player with an age that is too old' do
      it 'raises a PlayerError with a message indicating the age is invalid' do
        expect { Player.new(name: 'toto', age: '125', elo: '244') }.to raise_error(PlayerError) do |e|
          expect(e.message).to eq('Player toto has a problem. Invalid age')
        end
      end
    end

    context 'create a player with invalid elo' do
      it 'raises a PlayerError with a message indicating invalid data for elo' do
        expect { Player.new(name: 'toto', age: '24', elo: 'finish') }.to raise_error(PlayerError) do |e|
          expect(e.message).to eq('Player toto has a problem. Invalid data in elo')
        end
      end
    end

    context 'create a player with an age that is too small' do
      it 'raises a PlayerError with a message indicating the age is invalid' do
        expect { Player.new(name: 'toto', age: '24', elo: '24') }.to raise_error(PlayerError) do |e|
          expect(e.message).to eq('Player toto has a problem. Invalid elo')
        end
      end
    end
  end
end
