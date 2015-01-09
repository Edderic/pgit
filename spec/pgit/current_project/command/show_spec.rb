require 'spec_helper'

describe 'PGit::CurrentProject::Command::Show' do
  describe 'without any options' do
    it 'raises an error if there are no commands' do
      global_opts = {}
      opts = { list: true }
      args = {}

      expected_message = "Listing custom commands of the current project..."

      fake_commands = []
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml)
      fake_current_project = instance_double('PGit::CurrentProject',
                                             commands: fake_commands)

      allow(PGit::Configuration).to receive(:new).
        and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).
        with(fake_yaml).and_return(fake_current_project)
      allow_any_instance_of(PGit::CurrentProject::Command::Show).
        to receive(:puts)

      expect do
        PGit::CurrentProject::Command::Show.new(global_opts, opts, args)
      end.to raise_error PGit::Command::EmptyError
    end

    it 'lists the commands if there are commands' do
      global_opts = {}
      opts = { list: true }
      args = {}

      expected_message = "Listing custom commands of the current project..."

      fake_name = 'finish'
      fake_steps = ["git fetch origin master",
                    "git push origin :STORY_BRANCH"]
      fake_commands = { fake_name => fake_steps }
      fake_command_string = double('fake_command_string')
      fake_command = instance_double('PGit::Command', to_s: fake_command_string)
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml)
      fake_current_project = instance_double('PGit::CurrentProject',
                                             commands: fake_commands)

      allow(PGit::Configuration).to receive(:new).
        and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).
        with(fake_yaml).and_return(fake_current_project)
      allow(PGit::Command).to receive(:new).
        with(fake_name, fake_steps).and_return(fake_command)
      allow_any_instance_of(PGit::CurrentProject::Command::Show).
        to receive(:puts)
      app = PGit::CurrentProject::Command::Show.new(global_opts, opts, args)

      expect(app).to have_received(:puts).with(expected_message)
      expect(app).to have_received(:puts).with(fake_command_string)
    end
  end
end
