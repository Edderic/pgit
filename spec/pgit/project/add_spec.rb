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
      class SomeProject
        include ActiveModel::Validations
        validates_with PGit::Validators::ProjectValidator
        def get!
        end

        def kind
          'project'
        end
      end

      project = SomeProject.new
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

  describe 'the project is not valid' do
    it 'should raise an error' do
      error1_message = "Project id or api token might be invalid."
      errors = double('errors', full_messages: [error1_message])
      project = instance_double('PGit::Project', save!: nil, valid?: false, errors: errors)
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

      expect{ add.execute! }.to raise_error(PGit::Error::User, error1_message)
    end
  end
end
