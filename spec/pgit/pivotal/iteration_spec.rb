require 'spec_helper'

describe PGit::Pivotal::Iteration do
  describe '#new with hash' do
    it 'should instantiate stories' do
      iterations_string = File.read(File.join(PGit.root, 'spec', 'fixtures', 'iterations'))
      iteration_hashes = JSON.parse(iterations_string)
      first_iteration_hash = iteration_hashes.first
      current_project = instance_double('PGit::CurrentProject', id: 123, api_token: 'haba')
      allow(PGit::CurrentProject).to receive(:new).and_return(current_project)
      iteration = PGit::Pivotal::Iteration.new do |iteration|
        iteration.hash = first_iteration_hash
      end

      first_story = iteration.stories.first
      expect(first_story.id).to eq 90501214
    end
  end
end
