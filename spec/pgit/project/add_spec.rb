require 'spec_helper'

describe 'PGit::Project::Add' do
  describe 'user is on a project path that already exists' do
    it 'raises an error' do
      app = instance_double('PGit::Project::Application',
                            exists?: true)
      expect{PGit::Project::Add.new(app)}.to raise_error(PGit::Error::User, 'Project path already exists. See `pgit proj update --help.`')
    end
  end

  describe '#execute!' do
    it 'instantiates a project and saves it' do
      project = instance_double('PGit::Project', save!: nil)
      app = instance_double('PGit::Project::Application',
                            exists?: false,
                            project: project)
      adder = instance_double('PGit::Project::InteractiveAdder',
                              execute!: nil,
                              project: project,
                              save!: nil)
      allow(PGit::Project::InteractiveAdder).to receive(:new).with(project).and_return(adder)
      add = PGit::Project::Add.new(app)
      allow(add).to receive(:puts).with("Successfully added the project!")

      add.execute!

      expect(adder).to have_received(:save!)
      expect(adder).to have_received(:execute!)
      expect(add).to have_received(:puts).with("Successfully added the project!")
    end
  end
end
