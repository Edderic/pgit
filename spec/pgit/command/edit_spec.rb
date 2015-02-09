require 'spec_helper'

describe 'PGit::Command::Edit' do
  describe 'when the command already exists' do
    it 'should be successful' do
      name = 'existent_command'
      steps = ['existent_step']
      global_opts = {}
      opts = { name: name, steps: steps }
      args = []
      expected_message = "Successfully edited command 'existent_command' of the current project!"
      fake_command = instance_double('PGit::Command', name: name, steps: steps, save!: nil)

      fake_app = instance_double('PGit::Command::Application',
                                 command: fake_command,
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)

      edit = PGit::Command::Edit.new(fake_app)
      allow(edit).to receive(:puts).with(expected_message)
      edit.execute!

      expect(edit).to have_received(:puts).with(expected_message)
    end
  end

  describe 'when there the command does not exist' do
    it 'should raise an error' do
      non_existent_name = 'non_existent_command'
      non_existent_steps = ['existent_step']
      existent_name = 'existent_name'
      existent_steps= 'existent_steps'
      global_opts = {}
      opts = { name: non_existent_name, steps: non_existent_steps }
      args = []
      expected_message = "Cannot edit a command that does not exist in the current project. See `pgit cmd add --help` if you want to add a new command"
      fake_command = instance_double('PGit::Command',
                                     name: existent_name,
                                     steps: existent_steps,
                                     save!: nil)

      new_fake_command = instance_double('PGit::Command',
                                     name: non_existent_name,
                                     steps: non_existent_steps,
                                     save!: nil)

      fake_app = instance_double('PGit::Command::Application',
                                 command: new_fake_command,
                                 commands: [fake_command],
                                 args: args,
                                 opts: opts,
                                 global_opts: global_opts)

      edit = PGit::Command::Edit.new(fake_app)

      expect{ edit.execute! }.to raise_error(PGit::Error::User, expected_message)
    end
  end
end
