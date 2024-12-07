# frozen_string_literal: true

require 'optparse'

class Parser
  def self.parse(options)
    args = { output: false }

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: main.rb [options] FILE_PATH'

      opts.on('-o', '--output', 'Display result directly on stardard input') do
        args[:output] = true
      end

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    args
  end
end
