# frozen_string_literal: true

require_relative 'lib/parser'
require_relative 'lib/players_table'
require 'csv'
require 'debug'
require 'fileutils'
require 'benchmark'

class Main
  attr_reader :parser

  def initialize standard_arguments
    @parser = Parser.parse(standard_arguments)
    @file_path = standard_arguments.shift
    if @file_path.empty?
      warn 'You need to provide a file path as an argument.'
      exit
    end
  end

  def parse_file_to_csv
  end

  def read_csv
    CSV.read(@file_path, headers: true, header_converters: :downcase)
    rescue StandardError => e
      raise e unless e.to_s.match(/No such file or directory/)

      warn 'Invalid file path'
      exit
  end

  def csv_is_valid(csv)
    csv.each do |row|
      if row.fields.compact.size != row.headers.size
        warn "Invalid size row detected: #{row.inspect}"
        exit
      end
    end
  end
end

main = nil
players = nil
csv = nil
Benchmark.bm do |x|
  x.report('Initialize main') {
    # The initialization of main retrieves the arguments passed when launching the script,
    # parses them, and checks if the file_path is valid.
    main = Main.new(ARGV)
  }

  x.report('parse_read_check_invalid_csv') {
    # Depending on the requirements, a parsing function can be added to transform a file into a CSV format.
    main.parse_file_to_csv
    csv = main.read_csv
    main.csv_is_valid csv
  }

  x.report('Initialize PlayersTable') {
  begin
    players = PlayersTable.new({ csv: csv })
  rescue PlayersTableError => _e
    exit
  end
  }

  x.report('Find champions') {
    players.find_champions
  }
end

if (main.parser[:output])
  puts players.display_champions
else
  FileUtils.mkdir_p('champions')
  file = File.open("champions/#{Time.now}", 'w')
  file.puts(players.display_champions)
  file.close
end

