require 'spec_helper'

describe 'PGit::Command::Add' do
  describe 'when the command already exist' do
    it 'should raise an error since it already exists' do
      name = 'existent_command'
      steps = ['existent_step']
      global_opts = {}
      opts = { name: name, steps: steps }
      args = []
      expected_message = "Command 'existent_command' already exists in the current project. If you want to update the command, see `pgit command update --help`"
      fake_command = instance_double('PGit::Command', name: name, steps: steps)
      fake_project = instance_double('PGit::CurrentProject')

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts,
                                 current_project: fake_project)

      add = PGit::Command::Add.new(fake_app)

      expect{ add.execute! }.to raise_error PGit::Error::User, expected_message
    end
  end

  describe 'when there the command does not exist' do
    it 'should show the success message' do
      non_existent_name = 'non_existent_command'
      non_existent_steps = ['existent_step']
      existent_name = 'existent_name'
      existent_steps= 'existent_steps'
      global_opts = {}
      opts = { name: non_existent_name, steps: non_existent_steps }
      args = []
      expected_message = "Successfully added command 'non_existent_command' to the current project!"
      fake_project = instance_double('PGit::CurrentProject')
      fake_command = instance_double('PGit::Command',
                                     name: existent_name,
                                     steps: existent_steps,
                                     save: nil)

      new_fake_command = instance_double('PGit::Command',
                                     name: non_existent_name,
                                     steps: non_existent_steps,
                                     save: nil)

      allow(PGit::Command).to receive(:new).with(opts[:name], opts[:steps], fake_project).and_return(new_fake_command)

      fake_app = instance_double('PGit::Command::Application',
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts,
                                 current_project: fake_project)

      add = PGit::Command::Add.new(fake_app)
      allow(add).to receive(:puts)

      add.execute!

      expect(new_fake_command).to have_received(:save)
      expect(add).to have_received(:puts).with(expected_message)
    end
  end
end
