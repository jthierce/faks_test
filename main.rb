# frozen_string_literal: true

require_relative 'lib/parser'
require_relative 'lib/players_table'
require 'csv'
require 'debug'
require 'fileutils'

class Main
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
    CSV.read(file_path, headers: true, header_converters: :downcase)
    rescue StandardError => e
      raise e unless e.to_s.match(/No such file or directory/)

      warn 'Invalid file path'
      exit
    end
  end

  def csv_is_valid?(csv)
    csv.each do |row|
      if row.fields.compact.size != row.headers.size
        return false
      end
    end
    true
  end
end

main = Main.new(ARGV)

# Depending on what needed, but can add a parsing file to tranform a file to a csv
main.parse_file_to_csv
csv = main.read_csv

unless main.csv_is_valid? csv
  warn "Invalid size row detected: #{row.inspect}"
  exit
end

begin
  players = PlayersTable.new({ csv: csv })
rescue PlayersTableError => _e
  exit
end

players.find_champions
if (parser[:output])
  puts players.display_champions
else
  FileUtils.mkdir_p('champions')
  file = File.open("champions/#{Time.now}", 'w')
  file.puts(players.display_champions)
  file.close
end

