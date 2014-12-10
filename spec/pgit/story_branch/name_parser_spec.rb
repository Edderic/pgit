require 'pgit'

describe 'PGit::StoryBranch::NameParser' do
  describe '#name' do
    it 'should remove fluff words, remove periods,
        replace spaces with dashes, suffix story_id' do

      unparsed_name = "Deemphasize the Clue on the stimulus screen of multi-screen exercises."
      story_id = '12345'
      fake_story = double('PGit::Story', id: story_id, name: unparsed_name)

      name_parser = PGit::StoryBranch::NameParser.new(fake_story)
      parsed = name_parser.name

      expect(parsed).to eq "deemphasize-clue-stimulus-screen-multi-screen-exercises-12345"
    end

    xit 'should strip non-alpha-numerics like apostrophes' do
    end
  end
end
