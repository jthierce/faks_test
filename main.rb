# frozen_string_literal: true

require_relative 'lib/parser'
require_relative 'lib/player'
require 'csv'
require 'debug'

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

begin
  players = Player.new({ csv: csv })
rescue CSV::MalformedCSVError => _e
  exit
end
