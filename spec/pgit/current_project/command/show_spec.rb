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
      args = ['fake_command']

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
end
