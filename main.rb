# frozen_string_literal: true

require_relative 'lib/main'
require 'debug'

begin
  main = Main.new(ARGV)
  main.execute
rescue MainError => _e
  exit
end
