# frozen_string_literal: true

require_relative 'parser'
require_relative 'player_manager'
require_relative 'helpers/csv_helper'
require 'fileutils'

class MainError < StandardError;end

class Main
  attr_reader :parser

  def initialize standard_arguments
    @parser = Parser.parse(standard_arguments)
    @file_path = standard_arguments.shift
    if @file_path.nil?
      raise MainError.new('You need to provide a file path as an argument.')
    end
  end

  def execute
    begin
      csv = CsvHelper.read @file_path
      CsvHelper.check_mandatory_header(csv, Config::Variables::MANDATORY_HEADERS)
      # Might be unnecessary, could save execution time; depends on error handling and parsing strategy.
      CsvHelper.validate(csv)
    rescue CsvHelperError => e
      raise MainError.new(e.message)
    end

    player_manager = PlayerManager.new(csv)

    begin
      player_manager.load_players
    rescue PlayerError => e
      raise MainError.new(e.message)
    end

    champions = player_manager.champions
    output_results(champions.to_s)
  end

  private

  def output_results(results)
    if (parser[:output])
      puts results
    else
      FileUtils.mkdir_p('champions')
      file = File.open("champions/#{Time.now}", 'w')
      file.puts(results)
      file.close
    end
  end
end