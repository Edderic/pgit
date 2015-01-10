require 'spec_helper'

describe 'PGit::Command::Run' do
  describe '#run' do
    it 'raises a command not found exception if the item does not exist' do
      global_opts = {}
      opts = []
      args = ['non_existent_command']

      expected_message = "Listing custom commands of the current project..."

      fake_name = 'finish'
      fake_steps = ["git fetch origin master",
                    "git push origin :STORY_BRANCH"]
      fake_commands = { fake_name => fake_steps }
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
      allow_any_instance_of(PGit::Command::Run).
        to receive(:puts)
      allow(fake_command).to receive(:execute)
      app = PGit::Command::Run.new(global_opts, opts, args)

      expect do
        app.execute!
      end.to raise_error PGit::Command::NotFoundError
    end

    it 'calls execute on the command if it exists' do
      fake_name = 'finish'
      global_opts = []
      opts = []
      args = [fake_name]

      expected_message = "Listing custom commands of the current project..."

      fake_steps = ["git fetch origin master",
                    "git push origin :STORY_BRANCH"]
      fake_commands = { fake_name => fake_steps }
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
      allow_any_instance_of(PGit::Command::Run).
        to receive(:puts)
      allow(fake_command).to receive(:execute)

      app = PGit::Command::Run.new(global_opts, opts, args)
      app.execute!

      expect(fake_command).to have_received(:execute)
    end
  end
end
