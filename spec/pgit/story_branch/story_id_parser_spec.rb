require 'spec_helper'

describe PGit::StoryBranch::StoryIdParser do
  describe 'if it exists' do
    it 'parse should give us the id' do
      parser = PGit::StoryBranch::StoryIdParser.new("pgit-status-shows-information-about-current-story-if-there-is-one-97997060")
      expect(parser.parse).to eq "97997060"
    end
  end

  describe 'if does not exist' do
    it 'should raise an error' do
      parser = PGit::StoryBranch::StoryIdParser.new("pgit-status-shows-information-about-current-story-if-there-is-one")
      expect{parser.parse}.to raise_error(PGit::Error::User, 'The current branch is not associated with a story. Does not have a story id.')
    end
  end
end
