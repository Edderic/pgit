require_relative '../lib/pivotal'

describe 'PGit::StoryBranch::NameParser' do
  describe '#parse' do
    it 'should remove fluff words, remove periods,
        replace spaces with dashes, suffix story_id' do

      unparsed_name = "Deemphasize the Clue on the stimulus screen of multi-screen exercises."
      story_id = '12345'
      name_parser = PGit::StoryBranch::NameParser.new(unparsed_name, story_id)

      puts name_parser.methods(false)
      parsed = name_parser.parse
      expect(parsed).to eq "deemphasize-clue-stimulus-screen-multi-screen-exercises-12345"
    end
  end
end
