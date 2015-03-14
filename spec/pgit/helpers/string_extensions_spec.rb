require 'spec_helper'

describe 'PGit::Helpers::StringExtensions' do
  describe '#letter?' do
    it 'should be case insensitive' do
      expect('h').to be_letter('h')
      expect('h').to be_letter('H')
    end

    it 'should not match when length is greater than 1' do
      expect('hh').not_to be_letter('h')
    end
  end

  describe '#index?' do
    describe 'without passing an arg' do
      it 'should tell us if the argument is a (normal person) index' do
        expect('1').to be_index
        expect('100').to be_index
        expect('0').not_to be_index
        expect('1.1').not_to be_index
      end
    end
  end

  describe '#yes?' do
    it 'returns true if letter is y and false if not' do
      expect('y').to be_yes
      expect('Y').to be_yes
      expect('2').not_to be_yes
    end
  end

  describe '#no?' do
    it 'returns false if letter is not and false if not' do
      expect('n').to be_no
      expect('N').to be_no
      expect('y').not_to be_no
    end
  end

  describe '#cancel?' do
    it 'returns true if letter is c and false if not' do
      expect('c').to be_cancel
      expect('C').to be_cancel
      expect('y').not_to be_cancel
    end
  end
end
