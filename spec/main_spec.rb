# frozen_string_literal: true

require_relative '../lib/main'

describe Main do
  describe '.initialize' do
    context 'with no argument is given' do
      it 'raise a main error with message empty file' do
        expect {
          Main.new([])
        }.to raise_error(MainError, 'You need to provide a file path as an argument.')
      end
    end 
  end
end
