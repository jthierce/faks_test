# frozen_string_literal: true

require 'csv'
require_relative '../../lib/helpers/csv_helper'

describe CsvHelper do
  let(:players_file_path) { 'players_files' }

  describe 'validate' do
    context 'give a csv file with a row missing data' do
      let(:csv) { CSV.read("#{players_file_path}/invalid_csv.csv", headers: true, header_converters: :downcase) }

      it 'raise a CsvHelperError with a message invalid row' do
        expect {
          CsvHelper.validate(csv)
        }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to match(/Invalid size row detected:/)
        end
      end
    end
  end

  describe 'check_mandatory_header' do
    context 'give a csv file with invalid number of columns' do
      let(:csv) { CSV.read("#{players_file_path}/wrong_number_columns.csv", headers: true, header_converters: :downcase) }

      it 'raise a CsvHelperError with a message invalid headers' do
        expect {
          CsvHelper.check_mandatory_header(csv, Config::Variables::MANDATORY_HEADERS)
        }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to eq('Missing headers: elo')
        end
      end
    end

    context 'give a csv file with no headers' do
      let(:csv) { CSV.read("#{players_file_path}/no_header.csv", headers: true, header_converters: :downcase) }

      it 'raise a CsvHelperError with a message invalid headers' do
        expect { 
          CsvHelper.check_mandatory_header(csv, Config::Variables::MANDATORY_HEADERS)
        }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to eq("Missing headers: age, elo, name")
        end
      end
    end
  end

  describe 'read' do
    context 'give a invalide file path' do
      it 'raise a CsvHelperError with message invalid file path' do
        expect { CsvHelper.read('path_not_good') }.to raise_error(CsvHelperError) do |e|
          expect(e.message).to eq('Invalid file path')
        end
      end
    end

    context 'give a valid file path' do
      let(:file_path) { "#{players_file_path}/basic_players.csv" }

      it 'return array with the valid structure csv' do
        expect(CsvHelper.read(file_path)).to eq(CSV.read(file_path, headers: true, header_converters: :downcase))
      end
    end
  end
end