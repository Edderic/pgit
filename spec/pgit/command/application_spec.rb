require 'spec_helper'

describe 'PGit::Command::Application' do
  class SomeCommandApp < PGit::Command::Application
    def search
      args.first
    end
  end

  before do
    existent_name = 'existent_name'
    some_other_existent_name = 'some_other_existent_name'
    @global_opts, @opts, @args = [], [], [existent_name]

    fake_steps = ["git fetch origin master",
                  "git push origin :STORY_BRANCH"]
    fake_commands = { existent_name => fake_steps }
    fake_command_string = double('fake_command_string')
    @fake_command = instance_double('PGit::Command', to_s: fake_command_string, name: existent_name)
    fake_yaml = double('fake_yaml')
    fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml)
    fake_current_project = instance_double('PGit::CurrentProject',
                                           commands: fake_commands)

    allow(PGit::Configuration).to receive(:new).
      and_return(fake_configuration)
    allow(PGit::CurrentProject).to receive(:new).
      with(fake_yaml).and_return(fake_current_project)
    allow(PGit::Command).to receive(:new).
      with(existent_name, fake_steps).and_return(@fake_command)

    @app = SomeCommandApp.new(@global_opts, @opts, @args)
  end

  describe '#command' do
    it 'finds the command based on #search' do
      expect(@app.command).to eq @fake_command
    end
  end

  describe '#commands' do
    it 'returns the commands' do
      expect(@app.commands).to eq [@fake_command]
    end
  end

  describe '#global_opts' do
    it 'returns the global_opts' do
      expect(@app.global_opts).to eq @global_opts
    end
  end

  describe '#opts' do
    it 'returns the opts' do
      expect(@app.opts).to eq @opts
    end
  end

  describe '#args' do
    it 'returns the args' do
      expect(@app.args).to eq @args
    end
  end
end


