require 'spec_helper'

describe PGit::Status do
  describe 'when there is no associated story' do
    it 'should raise an error' do
      story_id = nil
      options = double('options')
      global_options = double('global_options')
      args = double('args')
      current_branch = instance_double('PGit::CurrentBranch', story_id: story_id)
      allow(PGit::CurrentBranch).to receive(:new).and_return(current_branch)
      status = PGit::Status.new(global_options, options, args)

      expect{status.execute!}.to raise_error(PGit::Error::User, 'The current branch is not associated with a story. Does not have a story id.')
    end
  end

  describe 'when there is an associated story' do
    it 'should puts info about the story' do
      story_id = 12345
      options = double('options')
      global_options = double('global_options')
      args = double('args')
      current_branch = instance_double('PGit::CurrentBranch', story_id: story_id)
      allow(PGit::CurrentBranch).to receive(:new).and_return(current_branch)
      story_hash = {'kind' => 'story'}
      story = double('PGit::Story', get!: story_hash)
      allow(PGit::Pivotal::Story).to receive(:new).with(current_branch.story_id).and_return(story)
      table = double('table')
      allow(table).to receive(:rows=).with(story_hash.to_a)
      allow(Terminal::Table).to receive(:new).and_yield(table).and_return(table)
      status = PGit::Status.new(global_options, options, args)
      allow(status).to receive(:puts).with(table)

      status.execute!
      expect(table).to have_received(:rows=).with(story_hash.to_a)
      expect(status).to have_received(:puts).with(table)
    end
  end
end
