# frozen_string_literal: true

require_relative '../lib/main'

describe Main do
  describe 'new' do
    context 'give no arguments' do
      it 'raise a main error with message empty file' do
        expect { Main.new([]) }.to raise_error(MainError) do |e|
          expect(e.message).to eq('You need to provide a file path as an argument.')
        end
      end
    end 
  end
end
