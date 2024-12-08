# frozen_string_literal: true

require 'csv'
require 'debug'
require_relative '../lib/players_table'

describe 'Global test' do
  PLAYERS_FILE_PATH = 'players_files'
  FIXTURES_FILE_PATH = 'spec/fixtures/results'

  describe 'when input is invalid' do
    # make a test when launch the programm with invalid file_path
    # make a test when launch the programm with nothing
  end

  describe 'when input is a error files' do
    before do
      @orig_stderr = $stderr
      $stderr = StringIO.new
    end

    it 'the error is too younger players' do
      csv = CSV.read("#{PLAYERS_FILE_PATH}/too_young_player.csv", headers: true, header_converters: :downcase)
      expect do
        PlayersTable.new({ csv: csv })
      end.to raise_error(PlayersTableError)
      $stderr.rewind
      expect($stderr.string.chomp).to match(/Player Iam Error has an invalid age/)
    end

    it 'the error is too older player' do
      csv = CSV.read("#{PLAYERS_FILE_PATH}/too_old_player.csv", headers: true, header_converters: :downcase)
      expect do
        PlayersTable.new({ csv: csv })
      end.to raise_error(PlayersTableError)
      $stderr.rewind
      expect($stderr.string.chomp).to match(/Player Iam Error has an invalid age/)
    end

    it 'the error is elo too low' do
      csv = CSV.read("#{PLAYERS_FILE_PATH}/elo_too_low.csv", headers: true, header_converters: :downcase)
      expect do
        PlayersTable.new({ csv: csv })
      end.to raise_error(PlayersTableError)
      $stderr.rewind
      expect($stderr.string.chomp).to eq("Player Iam Error has an invalid elo. (Too low)")
    end

    it 'the error is column missed' do
      csv = CSV.read("#{PLAYERS_FILE_PATH}/wrong_number_columns.csv", headers: true, header_converters: :downcase)
      expect do
        PlayersTable.new({ csv: csv })
      end.to raise_error(PlayersTableError)
      $stderr.rewind
      expect($stderr.string.chomp).to eq("Invalid headers")
    end

    it 'the error is invalid csv' do
      # csv = CSV.read("#{PLAYERS_FILE_PATH}/invalid_csv.csv", headers: true, header_converters: :downcase)
      # expect do
      #   PlayersTable.new({ csv: csv })
      # end.to raise_error(PlayersTableError)
      # $stderr.rewind
      # expect($stderr.string.chomp).to eq("Invalid headers")
    end

    it 'the error is missing headers' do
      csv = CSV.read("#{PLAYERS_FILE_PATH}/no_header.csv", headers: true, header_converters: :downcase)
      expect do
        PlayersTable.new({ csv: csv })
      end.to raise_error(PlayersTableError)
      $stderr.rewind
      expect($stderr.string.chomp).to eq("Invalid headers")
    end

    it 'the error is wrong data in elo column' do
      csv = CSV.read("#{PLAYERS_FILE_PATH}/wrong_data_in_elo.csv", headers: true, header_converters: :downcase)
      expect do
        PlayersTable.new({ csv: csv })
      end.to raise_error(PlayersTableError)
      $stderr.rewind
      expect($stderr.string.chomp).to eq("Player Richard Rapport has an invalid data in elo")
    end

    it 'the error is wrong data in age column' do
      csv = CSV.read("#{PLAYERS_FILE_PATH}/wrong_data_in_age.csv", headers: true, header_converters: :downcase)
      expect do
        PlayersTable.new({ csv: csv })
      end.to raise_error(PlayersTableError)
      $stderr.rewind
      expect($stderr.string.chomp).to eq("Player Aram Hakobyan has an invalid data in age")
    end

    after do
      $stderr = @orig_stderr
    end
  end

  describe 'Good files' do
    it 'get all champions on a simple file' do
      file_name = 'basic_players.csv'
      csv = CSV.read("#{PLAYERS_FILE_PATH}/#{file_name}", headers: true, header_converters: :downcase)
      player_table = PlayersTable.new({ csv: csv })
      player_table.find_champions
      file = File.open("#{FIXTURES_FILE_PATH}/#{file_name}")
      expect(player_table.display_champions).to eq(file.read)
      file.close
    end

    it 'return nothing when the file is empty' do
      file_name = 'empty_players.csv'
      csv = CSV.read("#{PLAYERS_FILE_PATH}/#{file_name}", headers: true, header_converters: :downcase)
      player_table = PlayersTable.new({ csv: csv })
      expect(player_table.display_champions).to eq('')
    end

    it 'get all champions with files with more columns' do
      file_name = 'more_columns.csv'
      csv = CSV.read("#{PLAYERS_FILE_PATH}/#{file_name}", headers: true, header_converters: :downcase)
      player_table = PlayersTable.new({ csv: csv })
      player_table.find_champions
      file = File.open("#{FIXTURES_FILE_PATH}/#{file_name}")
      expect(player_table.display_champions).to eq(file.read)
      file.close
    end

    it 'get all champions with people equality' do
      file_name = 'tied_player.csv'
      csv = CSV.read("#{PLAYERS_FILE_PATH}/#{file_name}", headers: true, header_converters: :downcase)
      player_table = PlayersTable.new({ csv: csv })
      player_table.find_champions
      file = File.open("#{FIXTURES_FILE_PATH}/#{file_name}")
      expect(player_table.display_champions).to eq(file.read)
      file.close
    end

    it 'get all champions with same elo but younger player' do
      file_name = 'same_elo_but_younger_player.csv'
      csv = CSV.read("#{PLAYERS_FILE_PATH}/#{file_name}", headers: true, header_converters: :downcase)
      player_table = PlayersTable.new({ csv: csv })
      player_table.find_champions
      file = File.open("#{FIXTURES_FILE_PATH}/#{file_name}")
      expect(player_table.display_champions).to eq(file.read)
      file.close
    end

    it 'get all champions with same age but higher elo' do
      file_name = 'same_age_but_higher_elo.csv'
      csv = CSV.read("#{PLAYERS_FILE_PATH}/#{file_name}", headers: true, header_converters: :downcase)
      player_table = PlayersTable.new({ csv: csv })
      player_table.find_champions
      file = File.open("#{FIXTURES_FILE_PATH}/#{file_name}")
      expect(player_table.display_champions).to eq(file.read)
      file.close
    end
  end
end
