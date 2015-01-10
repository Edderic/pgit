require 'spec_helper'

describe 'PGit::CurrentProject::Command::Show' do
  describe 'without any options' do
    it 'raises an error if there are no commands' do
      global_opts = []
      opts = []
      args = []

      allow_any_instance_of(PGit::Command::Application).
        to receive(:commands).and_return([])
      app = PGit::CurrentProject::Command::Show.new(global_opts, opts, args)

      expect { app.execute! }.to raise_error PGit::Command::EmptyError
    end

    it 'lists the commands if there are commands' do
      global_opts = []
      opts = []
      args = []

      expected_message = "Listing custom commands of the current project..."
      fake_formatted_command = instance_double('String')
      fake_command = instance_double('PGit::Command', to_s: fake_formatted_command)

      allow_any_instance_of(PGit::Command::Application).
        to receive(:commands).and_return([fake_command])
      allow_any_instance_of(PGit::Command::Application).to receive(:puts)
      app = PGit::CurrentProject::Command::Show.new(global_opts, opts, args)

      app.execute!

      expect(app).to have_received(:puts).with(expected_message)
      expect(app).to have_received(:puts).with(fake_formatted_command)
    end
  end

  describe 'when a command_name is passed in' do
    it 'should print the command if exists' do
      existent_command_name = 'fake_command'
      global_opts = []
      opts = []
      args = [existent_command_name]

      expected_message = "Listing custom command '#{existent_command_name}' of the current project..."
      fake_formatted_command = instance_double('String')
      fake_command = instance_double('PGit::Command',
                                     to_s: fake_formatted_command,
                                     name: existent_command_name)

      allow_any_instance_of(PGit::Command::Application).
        to receive(:commands).and_return([fake_command])
      allow_any_instance_of(PGit::Command::Application).to receive(:puts)
      app = PGit::CurrentProject::Command::Show.new(global_opts, opts, args)

      app.execute!

      expect(app).to have_received(:puts).with(expected_message)
      expect(app).to have_received(:puts).with(fake_formatted_command)
    end

    it 'should raise an error if the command does not exist' do
      nonexistent_command_name = 'non_existent_fake_command'
      existent_command_name = 'fake_command'
      global_opts = []
      opts = []
      args = [nonexistent_command_name]

      expected_message = "Command '#{nonexistent_command_name}' not found for this project"
      fake_formatted_command = instance_double('String')
      fake_command = instance_double('PGit::Command',
                                     to_s: fake_formatted_command,
                                     name: existent_command_name)

      allow_any_instance_of(PGit::Command::Application).
        to receive(:commands).and_return([fake_command])
      allow_any_instance_of(PGit::Command::Application).to receive(:puts)
      app = PGit::CurrentProject::Command::Show.new(global_opts, opts, args)

      expect{ app.execute! }.to raise_error PGit::Command::UserError, expected_message
    end
  end
end
