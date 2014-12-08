describe 'pgit' do
  describe 'story_branch' do
    it 'should output the help info for story_branch command' do
      result = `pgit story_branch`
      story_branch_matches = result.match(/story_branch/)
      name_match = result.match(/NAME/)

      expect(story_branch_matches.length).to be >= 1
      expect(name_match.length).to be >= 1
    end
  end

  # describe 'commit' do
    # describe 'on branch some-story-branch-1234' do
      # it 'should prepend the commit with [#1234]' do
#
      # end
    # end
  # end
end
