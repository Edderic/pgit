require 'spec_helper'

describe 'PGit::Command::Application' do
  describe '#execute' do
    it 'should call execute on the command if it exists' do
      global_opts = {}
      opts = { execute: 'finish' }
      args = {}

      expected_message = "Listing custom commands of the current project..."

      fake_name = 'finish'
      fake_steps = ["git fetch origin master",
                    "git push origin :STORY_BRANCH"]
      fake_commands = [{ fake_name => fake_steps }]
      fake_command_string = double('fake_command_string')
      fake_command = instance_double('PGit::Command', to_s: fake_command_string, name: 'finish')
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
      allow_any_instance_of(PGit::Command::Application).
        to receive(:puts)
      allow(fake_command).to receive(:execute)

      app = PGit::Command::Application.new(global_opts, opts, args)

      expect(fake_command).to have_received(:execute)
    end
  end

  describe '#list' do
    it 'should list the commands' do
      global_opts = {}
      opts = { list: true }
      args = {}

      expected_message = "Listing custom commands of the current project..."

      fake_name = 'finish'
      fake_steps = ["git fetch origin master",
                    "git push origin :STORY_BRANCH"]
      fake_commands = [{ fake_name => fake_steps }]
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
      allow_any_instance_of(PGit::Command::Application).
        to receive(:puts)
      app = PGit::Command::Application.new(global_opts, opts, args)

      expect(app).to have_received(:puts).with(expected_message)
      expect(app).to have_received(:puts).with(fake_command_string)
    end
  end
end
