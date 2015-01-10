require 'spec_helper'

describe 'PGit::Command::Run' do
  describe '#run' do
    it 'raises a command not found exception if the item does not exist' do
      global_opts = {}
      opts = []
      args = ['non_existent_command']

      allow_any_instance_of(PGit::Command::Application).
        to receive(:command).and_return(nil)
      app = PGit::Command::Run.new(global_opts, opts, args)

      expect do
        app.execute!
      end.to raise_error PGit::Command::NotFoundError
    end

    it 'calls execute on the command if it exists' do
      global_opts = {}
      opts = []
      args = ['existent_command']

      fake_command = instance_double('PGit::Command')
      allow(fake_command).to receive(:execute)
      allow_any_instance_of(PGit::Command::Application).
        to receive(:command).and_return(fake_command)
      app = PGit::Command::Run.new(global_opts, opts, args)
      app.execute!

      expect(fake_command).to have_received(:execute)
    end
  end
end
