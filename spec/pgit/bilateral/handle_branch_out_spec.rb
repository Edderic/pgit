require 'spec_helper'

describe PGit::Bilateral::HandleBranchOut do
  describe '#execute!' do
    it 'should create a git branch and checkout based on story name' do
      response = instance_double('Interactive::Response', whole_numbers
                                )
      options = { response: response, }
      PGit::Bilateral::HandleBranchOut.new(options)
    end
  end
end
