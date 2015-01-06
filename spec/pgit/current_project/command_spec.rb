require 'spec_helper'

describe 'PGit::CurrentProject::Command' do
  describe 'when there the command already exist' do
    it 'should raise an error since it already exists' do
      name = 'existent_command'
      steps = ['existent_step']
      opts = { name: name, steps: steps }
      expected_message = "Command 'existent_command' already exists in the current project. If you want to update the command, see `pgit command update --help`"
      fake_commands = { name => steps }
      fake_current_project = instance_double('PGit::CurrentProject', commands: fake_commands)
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml, yaml: fake_yaml)
      fake_command = instance_double('PGit::Command', name: name, steps: steps)
      allow(fake_current_project).to receive(:save)
      allow(PGit::Command).to receive(:new).with(name, steps).and_return(fake_command)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).with(fake_yaml).and_return(fake_current_project)
      current_project_command = PGit::CurrentProject::Command.new(name, steps)

      expect{ current_project_command.add }.to raise_error PGit::Command::UserError, expected_message
    end
  end

  describe 'when there the command does not exist' do
    it 'should show the success message' do
      name = 'non_existent_command'
      steps = ['some_step']
      expected_message = "Successfully added 'non_existent_command' to the current projects' commands!"
      existent_command_name = 'existent_command'
      existent_command_steps = ['existent_step_1', 'existent_step_2']
      fake_existent_commands = { existent_command_name => existent_command_steps }
      fake_current_project = instance_double('PGit::CurrentProject', commands: fake_existent_commands)
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml, yaml: fake_yaml)
      fake_command = instance_double('PGit::Command', name: name, steps: steps)
      fake_existent_command = instance_double('PGit::Command', name: existent_command_name, steps: existent_command_steps)
      allow(fake_command).to receive(:save)
      allow(fake_current_project).to receive(:save)
      allow(PGit::Command).to receive(:new).with(existent_command_name, existent_command_steps).and_return(fake_existent_command)
      allow(PGit::Command).to receive(:new).with(name, steps).and_return(fake_command)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).with(fake_yaml).and_return(fake_current_project)
      allow_any_instance_of(PGit::CurrentProject::Command).to receive(:puts)

      current_project_command = PGit::CurrentProject::Command.new(name, steps)
      current_project_command.add

      expect(fake_command).to have_received(:save)
      expect(current_project_command).to have_received(:puts).with(expected_message)
    end
  end

  describe '#update' do
    it 'should show a warning if the command does not exist' do
      name = 'non_existent_command'
      steps = ['some_step']
      expected_message = "Cannot update a command that does not exist in the current project. See `pgit command add --help` if you want to add a new command"
      existent_command_name = 'existent_command'
      existent_command_steps = ['existent_step_1', 'existent_step_2']
      fake_existent_commands = { existent_command_name => existent_command_steps }
      fake_current_project = instance_double('PGit::CurrentProject', commands: fake_existent_commands)
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml, yaml: fake_yaml)
      fake_command = instance_double('PGit::Command', name: name, steps: steps)
      fake_existent_command = instance_double('PGit::Command', name: existent_command_name, steps: existent_command_steps)
      allow(fake_current_project).to receive(:save)
      allow(PGit::Command).to receive(:new).with(existent_command_name, existent_command_steps).and_return(fake_existent_command)
      allow(PGit::Command).to receive(:new).with(name, steps).and_return(fake_command)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).with(fake_yaml).and_return(fake_current_project)
      allow_any_instance_of(PGit::CurrentProject::Command).to receive(:warn)

      current_project_command = PGit::CurrentProject::Command.new(name, steps)

      expect{current_project_command.update}.to raise_error PGit::Command::UserError, expected_message
    end

    it 'should write to the configuration if the command does exist' do
      name = 'existent_command'
      steps = ['existent_step']
      opts = { name: name, steps: steps }
      expected_message = "Successfully updated command 'existent_command' of the current project!"
      fake_commands = { name => steps }
      fake_current_project = instance_double('PGit::CurrentProject', commands: fake_commands)
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml, yaml: fake_yaml)
      fake_command = instance_double('PGit::Command', name: name, steps: steps)
      allow(fake_command).to receive(:save)
      allow(fake_current_project).to receive(:save)
      allow(PGit::Command).to receive(:new).with(name, steps).and_return(fake_command)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).with(fake_yaml).and_return(fake_current_project)
      allow_any_instance_of(PGit::CurrentProject::Command).to receive(:puts)

      current_project_command = PGit::CurrentProject::Command.new(name, steps)
      current_project_command.update

      expect(current_project_command).to have_received(:puts).with(expected_message)
      expect(fake_command).to have_received(:save)
    end
  end

  describe '#remove' do
    it 'removes the given command' do
      name = 'existent_command'
      steps = ['existent_step']
      empty_steps = []
      opts = { name: name, steps: steps }
      expected_message = "Successfully removed 'existent_command' from the current project"
      fake_commands = { name => steps }
      fake_current_project = instance_double('PGit::CurrentProject', commands: fake_commands)
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml, yaml: fake_yaml)
      fake_empty_steps_command = instance_double('PGit::Command', name: name, steps: empty_steps)
      fake_command = instance_double('PGit::Command', name: name, steps: steps)
      allow(fake_command).to receive(:save)
      allow(fake_current_project).to receive(:save)
      allow(PGit::Command).to receive(:new).with(name, steps).and_return(fake_command)
      allow(PGit::Command).to receive(:new).with(name, empty_steps).and_return(fake_command)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).with(fake_yaml).and_return(fake_current_project)
      allow_any_instance_of(PGit::CurrentProject::Command).to receive(:puts)

      current_project_command = PGit::CurrentProject::Command.new(name)
      current_project_command.remove

      expect(current_project_command).to have_received(:puts).with(expected_message)
      expect(fake_current_project.commands).to eq Hash.new
      expect(fake_current_project).to have_received(:save)
    end

    it 'throws an error if the command is not found' do
      nonexistent_name = 'some_nonexistent_command_name'
      existent_name = 'existent_command'
      steps = ['existent_step']
      empty_steps = []
      opts = { name: existent_name, steps: steps }
      expected_message = "Command 'some_nonexistent_command_name' does not exist in the current project"
      fake_existent_commands = { existent_name => steps }
      fake_current_project = instance_double('PGit::CurrentProject', commands: fake_existent_commands)
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml, yaml: fake_yaml)
      fake_empty_steps_command = instance_double('PGit::Command', name: nonexistent_name, steps: empty_steps)
      fake_command = instance_double('PGit::Command', name: existent_name, steps: steps)
      allow(fake_current_project).to receive(:save)
      allow(PGit::Command).to receive(:new).with(nonexistent_name, empty_steps).and_return(fake_empty_steps_command)
      allow(PGit::Command).to receive(:new).with(existent_name, steps).and_return(fake_command)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).with(fake_yaml).and_return(fake_current_project)
      allow_any_instance_of(PGit::CurrentProject::Command).to receive(:puts)

      current_project_command = PGit::CurrentProject::Command.new(nonexistent_name)

      expect{current_project_command.remove}.to raise_error PGit::Command::UserError, expected_message
    end
  end
end
