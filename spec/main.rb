# frozen_string_literal: true

require 'csv'
require_relative '../lib/main'
require_relative '../lib/champions'
require_relative '../lib/helpers/csv_helper'

describe 'Global test' do
  let(:players_file_path) { 'players_files' }
  let(:fixtures_file_path) { 'spec/fixtures/results' }

  describe 'CsvHelper.validate' do
    context 'give a csv file with a row missing data' do
      let(:csv) { CSV.read("#{players_file_path}/invalid_csv.csv", headers: true, header_converters: :downcase) }

      it 'raise a CsvHelperError with a message invalid row' do
        expect {
          CsvHelper.validate(csv)
        }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to match(/Invalid size row detected:/)
        end
      end
    end
  end

  describe 'CsvHelper.check_mandatory_header' do
    context 'give a csv file with invalid number of columns' do
      let(:csv) { CSV.read("#{players_file_path}/wrong_number_columns.csv", headers: true, header_converters: :downcase) }

      it 'raise a CsvHelperError with a message invalid headers' do
        expect {
          CsvHelper.check_mandatory_header(csv, Config::Variables::MANDATORY_HEADERS)
        }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to eq('Missing headers: elo')
        end
      end
    end

    context 'give a csv file with no headers' do
      let(:csv) { CSV.read("#{players_file_path}/no_header.csv", headers: true, header_converters: :downcase) }

      it 'raise a CsvHelperError with a message invalid headers' do
        expect { 
          CsvHelper.check_mandatory_header(csv, Config::Variables::MANDATORY_HEADERS)
        }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to eq("Missing headers: age, elo, name")
        end
      end
    end
  end

  describe 'CsvHelper.read' do
    context 'give a invalide file path' do
      it 'raise a CsvHelperError with message invalid file path' do
        expect { CsvHelper.read('path_not_good') }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to eq('Invalid file path')
        end
      end
    end

    context 'give a valid file path' do
      let(:file_path) { "#{players_file_path}/basic_players.csv" }

      it 'return array with the valid structure csv' do
        expect(CsvHelper.read(file_path)).to eq(CSV.read(file_path, headers: true, header_converters: :downcase))
      end
    end
  end

  describe 'Main.new' do
    context 'give no arguments' do
      it 'raise a main error with message empty file' do
        expect { Main.new([]) }.to raise_error(MainError) do |e|
          expect(e.message).to eq('You need to provide a file path as an argument.')
        end
      end
    end 
  end

  describe 'Player.new' do
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

  describe 'PlayerManager.load_players' do
    let(:csv) { CsvHelper.read("#{players_file_path}/#{file_name}") }
    let(:player_manager) { PlayerManager.new(csv) }

    context 'input is a csv player' do
        let(:file_name) { 'basic_players.csv' }

      it 'return a array of instance player class' do
        expect(player_manager.load_players).to all(be_an_instance_of(Player))
      end
    end
  end

  describe 'Champions.list' do
    let(:csv) { CsvHelper.read("#{players_file_path}/#{file_name}") }
    let(:player_manager) { PlayerManager.new(csv) }
    let(:file) { File.open("#{fixtures_file_path}/#{file_name}") }

    before do
      player_manager.load_players
    end

    context 'any player does not have the same age or elo' do
      let(:file_name) { 'basic_players.csv' }

      it 'returns all correct champions' do
        champions = Champions.new(player_manager.players)
        expect(champions.to_s).to eq(file.read())
      end
    end

    context 'some players have the same ages but higher elo' do
      let(:file_name) { 'same_age_but_higher_elo.csv' }

      it 'return the player with the higer elo' do
        champions = Champions.new(player_manager.players)
        expect(champions.to_s).to eq(file.read)
      end
    end

    context 'some players have the same elo but one is younger' do
      let(:file_name) { 'same_elo_but_younger_player.csv' }

      it 'return the player with the higer elo' do
        champions = Champions.new(player_manager.players)
        expect(champions.to_s).to eq(file.read)
      end
    end

    context 'we have no players' do
      let(:file_name) { 'empty_players.csv' }

      it 'return empty output' do
        champions = Champions.new(player_manager.players)
        expect(champions.to_s).to eq('')
      end
    end

    context 'players have the same age and elo' do
      let(:file_name) { 'tied_player.csv' }

      it 'return all the thied players' do
        champions = Champions.new(player_manager.players)
        expect(champions.to_s).to eq(file.read)
      end
    end
  end
end
