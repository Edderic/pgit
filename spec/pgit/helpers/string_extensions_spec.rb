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
end
