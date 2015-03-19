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
      config_project = instance_double('PGit::Project')
      projects = [config_project]
      app = instance_double('PGit::Project::Application',
                            exists?: false,
                            project: project,
                            projects: projects)
      adder = instance_double('PGit::Project::InteractiveAdder',
                              execute!: nil,
                              project: project,
                              save!: nil)
      reuse_adder = instance_double('PGit::Project::ReuseApiTokenAdder',
                                    execute!: nil,
                                    project: project)
      allow(PGit::Project::InteractiveAdder).to receive(:new).with(project).and_return(adder)
      allow(PGit::Project::ReuseApiTokenAdder).to receive(:new).with(project, projects).and_return(reuse_adder)
      add = PGit::Project::Add.new(app)
      allow(add).to receive(:puts).with("Successfully added the project!")

      add.execute!

      expect(reuse_adder).to have_received(:execute!)
      expect(adder).to have_received(:execute!)
      expect(adder).to have_received(:save!)
      expect(add).to have_received(:puts).with("Successfully added the project!")
    end
  end
end
