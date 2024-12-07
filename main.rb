# frozen_string_literal: true

require_relative 'lib/parser'
require_relative 'lib/players_table'
require 'csv'
require 'debug'
require 'fileutils'

parser = Parser.parse(ARGV)
file_path = ARGV.shift

warn 'You need to provide a file path as an argument.' if file_path.empty?

# Depending on what needed, but can add a parsing file to tranform a file to a csv

begin
  csv = CSV.read(file_path, headers: true, header_converters: :downcase)
rescue StandardError => e
  raise e unless e.to_s.match(/No such file or directory/)

  warn 'Invalid file path'
  exit
end

csv.each do |row|
  if row.fields.compact.size != row.headers.size
    warn "Invalid size row detected: #{row.inspect}"
    exit
  end
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

