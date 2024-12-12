# frozen_string_literal: true

require_relative 'lib/main'

begin
  main = Main.new(ARGV)
  main.execute
rescue MainError => e
  warn(e.message)
  exit
end
