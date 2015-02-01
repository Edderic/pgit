require 'spec_helper'

describe 'PGit::Command::Show' do
  before { Rainbow.enabled = false }
  describe 'without any options' do
    it 'raises an error if there are no commands' do
      global_opts = []
      opts = []
      args = []

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)
      app = PGit::Command::Show.new(fake_app)
      message = "No commands are listed for this project. Run `pgit command add --help` for more info."
      expect { app.execute! }.to raise_error(PGit::Error::User, message)
    end

    it 'lists the commands if there are commands' do
      global_opts = []
      opts = []
      args = []

      expected_message = "Listing custom commands of the current project..."
      fake_formatted_command = instance_double('String')
      fake_command = instance_double('PGit::Command', to_s: fake_formatted_command)

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)
      show = PGit::Command::Show.new(fake_app)
      allow(show).to receive(:puts)

      show.execute!

      expect(show).to have_received(:puts).with(expected_message)
      expect(show).to have_received(:puts).with(fake_formatted_command)
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

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)
      show = PGit::Command::Show.new(fake_app)
      allow(show).to receive(:puts)

      show.execute!

      expect(show).to have_received(:puts).with(expected_message)
      expect(show).to have_received(:puts).with(fake_formatted_command)
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

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)
      show = PGit::Command::Show.new(fake_app)

      expect{ show.execute! }.to raise_error PGit::Error::User, expected_message
    end
  end
end
