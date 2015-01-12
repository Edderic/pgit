require 'spec_helper'

describe 'PGit::Command::Run' do
  describe '#run' do
    it 'raises a command not found exception if the item does not exist' do
      global_opts = {}
      opts = []
      args = ['non_existent_command']

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)
      allow(PGit::Command::Application).to receive(:new).with(global_opts, opts, args).and_return(fake_app)

      app = PGit::Command::Application.new(global_opts, opts, args)
      run = PGit::Command::Run.new(app)

      expect do
        run.execute!
      end.to raise_error PGit::Command::NotFoundError
    end

    it 'calls execute on the command if it exists' do
      existent_name = 'existent_command'
      global_opts = {}
      opts = []
      args = [existent_name]

      fake_command = instance_double('PGit::Command', name: existent_name)
      allow(fake_command).to receive(:execute)
      fake_app = instance_double('PGit::Command::Application',
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)
      allow(PGit::Command::Application).to receive(:new).with(global_opts, opts, args).and_return(fake_app)

      app = PGit::Command::Application.new(global_opts, opts, args)
      run = PGit::Command::Run.new(app)
      run.execute!

      expect(fake_command).to have_received(:execute)
    end
  end
end
