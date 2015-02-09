require 'spec_helper'

describe 'PGit::Command' do
  before { Rainbow.enabled = false }

  describe '#remove!' do
    it 'removes the (optional) key-value pair from the current project' do
      name = "finish"
      steps = ["git checkout master", "git fetch"]
      fake_commands = instance_double('Array', reject!: nil, :<< => nil)
      current_project = instance_double('PGit::CurrentProject',
                                        commands: fake_commands,
                                        save!: nil)

      command = PGit::Command.new(name, steps, current_project)
      allow(current_project).to receive(:remove!).with(command)
      command.remove!

      expect(current_project.commands).to have_received(:reject!)
      expect(current_project).to have_received(:save!)
    end
  end

  describe '#save!' do
    it 'saves the command if the key does not exist for the current project' do
      name = "finish"
      steps = ["git checkout master", "git fetch"]
      fake_commands = instance_double('Array', reject!: nil, :<< => nil)
      current_project = instance_double('PGit::CurrentProject',
                                        commands: fake_commands,
                                        :commands= => nil)
      allow(current_project).to receive(:save!)

      command = PGit::Command.new(name, steps, current_project)
      command.save!

      expect(current_project.commands).to have_received(:reject!)
      expect(current_project).to have_received(:save!)
    end
  end

  describe '#to_h' do
    it 'explicitly returns a hash' do
      chompable = double('String')
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      name = "finish"
      steps = [fake_first_step, fake_second_step]

      fake_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, fake_project)
      expected_hash = {
        "finish" => ["echo hi", "echo hello"],
        "start" => ["git checkout bla-123"]
      }

      expect(command.to_h.merge({ "start" => ["git checkout bla-123"]})).to eq expected_hash
    end
  end

  describe '#to_hash' do
    it 'implicitly converts the object into a hash' do
      chompable = double('String')
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      name = "finish"
      steps = [fake_first_step, fake_second_step]
      current_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, current_project)
      expected_hash = {
        "finish" => ["echo hi", "echo hello"],
        "start" => ["git checkout bla-123"]
      }

      merged = { "start" => [ "git checkout bla-123"] }.merge(command)
      expect(merged).to eq expected_hash
    end
  end

  describe '#name' do
    it 'should return the name' do
      chompable = double('String')
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      name = "finish"
      steps = [fake_first_step, fake_second_step]
      current_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, current_project)
      name = command.name

      expect(name).to eq "finish"
    end
  end

  describe '#steps' do
    it 'should return the steps' do
      chompable = double('String')
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      steps = [fake_first_step, fake_second_step]
      name = "finish"
      current_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, current_project)
      steps = command.steps

      expect(steps).to eq steps
    end
  end

  describe '#to_s' do
    it 'should return the string version' do
      stringified = <<-TO_S
        finish:
          echo hi
          echo hello
      TO_S

      stringified = PGit::Helpers::Heredoc.remove_front_spaces(stringified)
      chompable = double('String')
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
      fake_first_step = "echo hi"
      fake_second_step = "echo hello"
      steps = [fake_first_step, fake_second_step]
      name = "finish"
      current_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, current_project)
      string = command.to_s

      expect(string).to eq stringified
    end
  end

  describe '#execute' do
    it 'executes each line' do
      chompable = double('String')
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
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
      current_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, current_project)

      command.execute

      expect(command).to have_received(:puts).with fake_first_response
      expect(command).to have_received(:puts).with fake_second_response
    end

    it 'replaces STORY_BRANCH with the current branch' do
      chompable = double('String')
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
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
      current_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, current_project)

      command.execute

      expect(command).to have_received(:puts).with fake_command_step_response
    end

    it 'says what is about to be executed and asks for the next step' do
      chompable = double('String')
      allow_any_instance_of(PGit::Command).to receive(:puts)
      allow(chompable).to receive(:chomp).and_return('Y')
      allow(STDIN).to receive(:gets).and_return(chompable)
      fake_command_step = "echo hello"
      name = "finish"
      message_to_be_executed = "About to execute 'echo hello'. Proceed? [Y/s/q]"
      steps = [fake_command_step]
      current_project = instance_double('PGit::CurrentProject')
      command = PGit::Command.new(name, steps, current_project)

      command.execute

      expect(command).to have_received(:puts).with message_to_be_executed
    end

    describe 'user answers "Y"' do
      it 'should go to the next step' do
        allow_any_instance_of(PGit::Command).to receive(:puts)

        chompable = double('String')
        allow(chompable).to receive(:chomp).and_return('Y')
        allow(STDIN).to receive(:gets).and_return(chompable)
        fake_command_step = "echo hello"
        name = "finish"
        message_to_be_executed = "About to execute 'echo hello'. Proceed? [Y/s/q]"
        steps = [fake_command_step]
        current_project = instance_double('PGit::CurrentProject')
        command = PGit::Command.new(name, steps, current_project)

        command.execute

        expect(command).to have_received(:puts).with message_to_be_executed
      end
    end

    describe 'user answers "s"' do
      it 'should go to the next step' do
        allow_any_instance_of(PGit::Command).to receive(:puts)

        chompable = double('String')
        allow(chompable).to receive(:chomp).and_return('s')
        allow(STDIN).to receive(:gets).and_return(chompable)
        fake_command_step = "echo hello"
        name = "finish"
        message_to_be_executed = "Skipping..."
        steps = [fake_command_step]
        current_project = instance_double('PGit::CurrentProject')
        command = PGit::Command.new(name, steps, current_project)

        command.execute

        expect(command).to have_received(:puts).with message_to_be_executed
      end
    end

    describe 'user answers "q"' do
      it 'should quit' do
        allow_any_instance_of(PGit::Command).to receive(:puts)

        chompable = double('String')
        allow(chompable).to receive(:chomp).and_return('q', 's')
        allow(STDIN).to receive(:gets).and_return(chompable)
        fake_first_step = "echo hello"
        fake_second_step = "echo hi"
        name = "finish"
        message_to_be_executed = "Quitting..."
        steps = [fake_first_step, fake_second_step]
        current_project = instance_double('PGit::CurrentProject')
        command = PGit::Command.new(name, steps, current_project)

        command.execute

        expect(command).to have_received(:puts).with message_to_be_executed
        expect(command).not_to have_received(:puts).with "Skipping..."
      end
    end

    describe 'user answers with nonsense' do
      it 'should repeat the legal options without moving to the end' do
        allow_any_instance_of(PGit::Command).to receive(:puts)

        chompable = double('String')
        allow(chompable).to receive(:chomp).and_return('l', 'y')
        allow(STDIN).to receive(:gets).and_return(chompable)
        fake_command_step = "echo hello"
        execution_message = "Executing 'echo hello'..."
        name = "finish"
        message = <<-LEGAL_OPTIONS
          y  - yes
          s  - skip
          q  - quit
        LEGAL_OPTIONS

        message = PGit::Helpers::Heredoc.remove_front_spaces(message)
        steps = [fake_command_step]
        current_project = instance_double('PGit::CurrentProject')
        command = PGit::Command.new(name, steps, current_project)

        command.execute

        expect(command).to have_received(:puts).with message
        expect(command).to have_received(:puts).with execution_message
      end
    end
  end
end
