describe 'pgit' do
  describe 'story_branch' do
    it 'should output the help info for story_branch command' do
      pgit_expanded_path = File.expand_path('bin/pgit')

      result = `bundle exec #{pgit_expanded_path} story_branch`
      story_branch_matches = result.match(/story_branch/)
      name_match = result.match(/NAME/)

      expect(story_branch_matches.length).to be >= 1
      expect(name_match.length).to be >= 1
    end
  end

  # describe 'install' do
    # it 'should ask the user some questions' do
      # pgit_expanded_path = File.expand_path('bin/pgit')
      # message = "This will save the config file on ~/.pgit.rc.yml"
      # allow(Kernel).to receive(:puts).with message
#
      # result = `bundle exec #{pgit_expanded_path} install`
      # expect(Kernel).to have_received(:puts).with message
    # end
  # end

  # describe 'commit' do
    # describe 'on branch some-story-branch-1234' do
      # it 'should prepend the commit with [#1234]' do
#
      # end
    # end
  # end
end
