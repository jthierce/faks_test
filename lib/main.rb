# frozen_string_literal: true

require_relative 'parser'
require_relative 'players_table'
require 'csv'
require 'fileutils'

class MainError < StandardError;end

class Main
  attr_reader :parser

  def initialize standard_arguments
    @parser = Parser.parse(standard_arguments)
    @file_path = standard_arguments.shift
    if @file_path.nil?
      warn 'You need to provide a file path as an argument.'
      raise MainError.new('Invalid file path')
    end
  end

  def execute
    parse_file_to_csv
    csv = read_csv

    # Might be unnecessary, could save execution time; depends on error handling and parsing strategy.
    csv_is_valid csv

    players = initialize_players_table(csv)
    players.find_champions
    output_results(players)
  end

  private

  def parse_file_to_csv
    # Implementation to transform a file into CSV if needed
  end

  def read_csv
    CSV.read(@file_path, headers: true, header_converters: :downcase)
    rescue StandardError => e
      raise e unless e.to_s.match(/No such file or directory/)

      warn 'Invalid file path'
      raise MainError.new('Invalid file path')
  end

  def csv_is_valid(csv)
    csv.each do |row|
      if row.fields.compact.size != row.headers.size
        warn "Invalid size row detected: #{row.inspect}"
        raise MainError.new('Invalid size row')
      end
    end
  end

  def initialize_players_table(csv)
    PlayersTable.new({ csv: csv })
  rescue PlayersTableError => e
    raise MainError.new(e)
  end

  def output_results(players)
    if (parser[:output])
      puts players.display_champions
    else
      FileUtils.mkdir_p('champions')
      file = File.open("champions/#{Time.now}", 'w')
      file.puts(players.display_champions)
      file.close
    end
  end
end