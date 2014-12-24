require 'spec_helper'

describe 'PGit::StringExtensions' do
  describe '#letter?' do
    it 'should be case insensitive' do
      expect('h').to be_letter('h')
      expect('h').to be_letter('H')
    end

    it 'should not match when length is greater than 1' do
      expect('hh').not_to be_letter('h')
    end
  end
end
