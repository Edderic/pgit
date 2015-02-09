require 'spec_helper'

describe 'PGit::Command::Remove' do
  describe 'when the command already exists' do
    it 'should be successful' do
      name = 'existent_command'
      steps = ['existent_step']
      global_opts = {}
      opts = { name: name }
      args = []
      expected_message = "Successfully removed command 'existent_command' from the current project!"
      fake_command = instance_double('PGit::Command', name: name,
                                                      steps: steps,
                                                      save!: nil,
                                                      remove!: nil)
      new_command = instance_double('PGit::Command', name: name,
                                                      steps: steps,
                                                      save!: nil,
                                                      remove!: nil)

      project = instance_double('PGit::CurrentProject')

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [fake_command],
                                 command: new_command,
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts,
                                 current_project: project)

      allow(PGit::Command).to receive(:new).with(name, ['fake_steps'], project).and_return(fake_command)
      remove = PGit::Command::Remove.new(fake_app)
      allow(remove).to receive(:puts)
      remove.execute!

      expect(remove).to have_received(:puts).with(expected_message)
    end
  end

  describe 'when there the command does not exist' do
    it 'should raise an error' do
      non_existent_name = 'non_existent_command'
      non_existent_steps = ['existent_step']
      existent_name = 'existent_name'
      existent_steps= 'existent_steps'
      global_opts = {}
      opts = { name: non_existent_name }
      args = []
      expected_message = "Cannot remove a command that does not exist in the current project. See `pgit cmd add --help` if you want to add a new command"
      project = instance_double('PGit::CurrentProject')
      fake_command = instance_double('PGit::Command',
                                     name: existent_name,
                                     steps: existent_steps,
                                     save!: nil)

      new_fake_command = instance_double('PGit::Command',
                                     name: non_existent_name,
                                     steps: non_existent_steps,
                                     save!: nil)

      allow(PGit::Command).to receive(:new).with(opts[:name], ['fake_steps'], project).and_return(new_fake_command)

      fake_app = instance_double('PGit::Command::Application',
                                 command: new_fake_command,
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts,
                                 current_project: project)

      remove = PGit::Command::Remove.new(fake_app)

      expect{ remove.execute! }.to raise_error(PGit::Error::User, expected_message)
    end
  end
end
