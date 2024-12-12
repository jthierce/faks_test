# frozen_string_literal: true

require 'csv'

class CsvHelperError < StandardError;end

module CsvHelper
  def self.read(file_path)
    CSV.read(file_path, headers: true, header_converters: :downcase)
  rescue StandardError => e
    raise e unless e.to_s.match(/No such file or directory/)

    raise CsvHelperError.new('Invalid file path')
  end

  def self.validate(csv)
    csv.each do |row|
      if row.fields.compact.size != row.headers.size
        raise CsvHelperError, "Invalid size row detected: #{row.inspect}"
      end
    end
  end

  def self.check_mandatory_header(csv, mandatory_header)
    missing_headers = Config::Variables::MANDATORY_HEADERS.reject do |header|
      csv.headers.include?(header)
    end

    unless missing_headers.empty?
      raise CsvHelperError.new("Missing headers: #{missing_headers.join(', ')}")
    end
  end
end
