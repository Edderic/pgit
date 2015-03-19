require 'spec_helper'

describe 'PGit::Project::Remove' do
  describe '#execute' do
    describe 'project path matches a project path in the configuration' do
      describe 'user answers yes' do
        it 'should remove the project' do
          path = 'some/path'
          common_path = 'some/path'
          project = instance_double('PGit::Project', path: common_path, exists?: true)
          config_project_1 = instance_double('PGit::Project', path: common_path)
          config_project_2 = instance_double('PGit::Project', path: 'some/other/path')
          projects = [config_project_1, config_project_2]
          app = instance_double('PGit::Project::Application', project: project, projects: projects)
          rm = PGit::Project::Remove.new(app)
          question = "Are you sure you want to remove #{path} from the configuration file?"
          config = double('config', :question= => nil, :options= => nil)
          confirmation_question = instance_double('Interactive::Question')
          options = [:yes, :no]
          response = double('response', yes?: true)
          allow(Interactive::Question).to receive(:new).and_yield(config).and_return(confirmation_question)
          allow(config).to receive(:question).with(question)
          allow(config).to receive(:options).with(options)
          allow(confirmation_question).to receive(:ask_and_wait_for_valid_response).and_yield(response)
          allow(rm).to receive(:puts)
          allow(project).to receive(:remove!)

          rm.execute!
          expect(Interactive::Question).to have_received(:new)
          expect(config).to have_received(:question=).with(question)
          expect(config).to have_received(:options=).with(options)
          expect(confirmation_question).to have_received(:ask_and_wait_for_valid_response)
          expect(rm).to have_received(:puts).with("Removing #{path} from the configuration file...")
          expect(rm).to have_received(:puts).with("Removed.")
          expect(project).to have_received(:remove!)
        end
      end

      describe 'user answers no' do
        it 'should respond with "Canceling..."' do
          path = 'some/path'
          common_path = 'some/path'
          project = instance_double('PGit::Project', path: common_path, exists?: true)
          config_project_1 = instance_double('PGit::Project', path: common_path)
          config_project_2 = instance_double('PGit::Project', path: 'some/other/path')
          projects = [config_project_1, config_project_2]
          app = instance_double('PGit::Project::Application', project: project, projects: projects)
          rm = PGit::Project::Remove.new(app)
          question = "Are you sure you want to remove #{path} from the configuration file?"
          config = double('config', :question= => nil, :options= => nil)
          confirmation_question = instance_double('Interactive::Question')
          options = [:yes, :no]
          response = double('response', yes?: false, no?: true)
          allow(Interactive::Question).to receive(:new).and_yield(config).and_return(confirmation_question)
          allow(config).to receive(:question).with(question)
          allow(config).to receive(:options).with(options)
          allow(confirmation_question).to receive(:ask_and_wait_for_valid_response).and_yield(response)
          allow(rm).to receive(:puts)
          allow(project).to receive(:remove!)

          rm.execute!
          expect(Interactive::Question).to have_received(:new)
          expect(config).to have_received(:question=).with(question)
          expect(config).to have_received(:options=).with(options)
          expect(confirmation_question).to have_received(:ask_and_wait_for_valid_response)
          expect(rm).to have_received(:puts).with("Cancelling...")
          expect(rm).not_to have_received(:puts).with("Removing #{path} from the configuration file...")
          expect(project).not_to have_received(:remove!)
        end
      end
    end
  end

  describe 'project path does not match a project path in the configuration' do
    it 'raises an error' do
      path = 'some/path'
      some_path_not_in_config = 'some/path/not/in/config'
      project = instance_double('PGit::Project', path: some_path_not_in_config, exists?: false)
      config_project_1 = instance_double('PGit::Project', path: path)
      config_project_2 = instance_double('PGit::Project', path: 'some/other/path')
      projects = [config_project_1, config_project_2]
      app = instance_double('PGit::Project::Application', project: project, projects: projects)
      expect{PGit::Project::Remove.new(app)}.to raise_error(PGit::Error::User, "#{some_path_not_in_config} is not in the configuration file.")
    end
  end
end
