require 'spec_helper'

describe PGit::Pivotal::Project do
  describe '.ancestors' do
    it 'should include PGit::Pivotal::IndividualRequest' do
      expect(PGit::Pivotal::Project.ancestors).to include(PGit::Pivotal::IndividualRequest)
    end
  end
end
