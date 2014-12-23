require 'spec_helper'

describe 'Command' do
  describe '#name' do
    it 'should return the name' do
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      name = "finish"
      steps = [fake_first_step, fake_second_step]
      command = PGit::Command.new(name, steps)
      name = command.name

      expect(name).to eq "finish"
    end
  end

  describe '#steps' do
    it 'should return the steps' do
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      steps = [fake_first_step, fake_second_step]
      name = "finish"
      command = PGit::Command.new(name, steps)
      steps = command.steps

      expect(steps).to eq steps
    end
  end

  describe '#execute' do
    it 'executes each line' do
      fake_current_branch = "some_feature_branch_12345678"
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      fake_first_response = "hi"
      fake_second_response = "hello"
      name = "finish"
      steps = [fake_first_step, fake_second_step]
      allow_any_instance_of(PGit::CurrentBranch).to receive(:name).
        and_return(fake_current_branch)
      allow_any_instance_of(PGit::Command).to receive(:`).
        with(fake_first_step).and_return(fake_first_response)
      allow_any_instance_of(PGit::Command).to receive(:`).
        with(fake_second_step).and_return(fake_second_response)
      allow_any_instance_of(PGit::Command).to receive(:puts)
      command = PGit::Command.new(name, steps)

      command.execute

      expect(command).to have_received(:puts).with fake_first_response
      expect(command).to have_received(:puts).with fake_second_response
    end

    it 'replaces STORY_BRANCH with the current branch' do
      fake_current_branch = "some_feature_branch_12345678"
      fake_command_step = "git branch -d #{fake_current_branch}"
      fake_command_step_response = "Deleted branch some_feature_branch_12345678"
      allow_any_instance_of(PGit::CurrentBranch).to receive(:name).
        and_return(fake_current_branch)
      allow_any_instance_of(PGit::Command).to receive(:`).
        with(fake_command_step).and_return(fake_command_step_response)
      allow_any_instance_of(PGit::Command).to receive(:puts)
      name = "finish"
      steps = [fake_command_step]
      command = PGit::Command.new(name, steps)

      command.execute

      expect(command).to have_received(:puts).with fake_command_step_response
    end
  end
end
