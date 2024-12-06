# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../main'

describe Champion do
  describe 'when input is invalid' do
    # make a test when launch the programm with invalid file_path
    # make a test when launch the programm with nothing
  end
  describe 'when input is a error files' do
    it 'the error is too younger players' do
    end

    it 'the error is too older player' do
    end

    it 'the error is elo too low' do
    end

    it 'the error is column missed' do
    end

    it 'the error is invalid csv' do
    end

    it 'the error is missing headers' do
    end

    it 'the error is wrong data in elo column' do
    end

    it 'the error is wrong data in age column' do
    end
  end

  describe 'Good files' do
    it 'get all champions on a simple file' do
    end

    it 'return nothing when the file is empty' do
    end

    it 'get all champions with files with more columns' do
    end

    it 'get all champions with people equality' do
    end

    it 'get all champions with same elo but younger player' do
    end

    it 'get all champions with same age but higher elo'
  end
end
