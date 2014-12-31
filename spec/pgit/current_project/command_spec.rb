require 'spec_helper'

describe 'PGit::CurrentProject::Command' do
  describe 'when there the command already exist' do
    it 'should warn the user that it already exists' do
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
      allow_any_instance_of(PGit::CurrentProject::Command).to receive(:warn)

      current_project_command = PGit::CurrentProject::Command.new(name, steps)
      current_project_command.add

      expect(current_project_command).to have_received(:warn).with(expected_message)
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
      allow(fake_current_project).to receive(:save)
      allow(PGit::Command).to receive(:new).with(existent_command_name, existent_command_steps).and_return(fake_existent_command)
      allow(PGit::Command).to receive(:new).with(name, steps).and_return(fake_command)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).with(fake_yaml).and_return(fake_current_project)
      allow_any_instance_of(PGit::CurrentProject::Command).to receive(:puts)

      current_project_command = PGit::CurrentProject::Command.new(name, steps)
      current_project_command.add

      expect(current_project_command).to have_received(:puts).with(expected_message)
    end
  end
end
