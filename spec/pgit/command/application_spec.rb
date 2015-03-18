require 'spec_helper'

describe 'PGit::Command::Application' do
  class SomeCommandApp < PGit::Command::Application
  end

  before do
    existent_name = 'existent_name'
    some_other_existent_name = 'some_other_existent_name'
    new_name = 'new_name'
    new_steps = ['echo step1', 'echo step2']
    @global_opts, @opts, @args = {}, { 'name' => new_name, 'steps' => new_steps}, [existent_name]

    fake_steps = ["git fetch origin master",
                  "git push origin :STORY_BRANCH"]
    fake_command_string = double('fake_command_string')
    @new_command = instance_double('PGit::Command', name: new_name, steps: new_steps)
    @fake_command = instance_double('PGit::Command', to_s: fake_command_string, name: existent_name)
    @fake_commands = [@fake_command]
    fake_yaml = double('fake_yaml')
    fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml)
    @fake_current_project = instance_double('PGit::CurrentProject',
                                            commands: @fake_commands)

    allow(PGit::Configuration).to receive(:new).
      and_return(fake_configuration)
    allow(PGit::CurrentProject).to receive(:new).
      with(fake_configuration).and_return(@fake_current_project)
    allow(PGit::Command).to receive(:new).
      with(existent_name, fake_steps, @fake_current_project).and_return(@fake_command)
    allow(PGit::Command).to receive(:new).
      with(new_name, new_steps, @fake_current_project).and_return(@new_command)

    @app = SomeCommandApp.new(@global_opts, @opts, @args)
  end

  describe '#commands' do
    it 'returns the commands' do
      expect(@app.commands).to eq @fake_commands
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

  describe '#current_project' do
    it 'return the current project' do
      expect(@app.current_project).to eq @fake_current_project
    end
  end

  describe '#command' do
    it 'returns the command' do
      expect(@app.command).to eq @new_command
    end
  end

  describe 'passing in opts without steps' do
    it 'should default steps of the command to [:no_steps_provided]' do
      class SomeOtherCommandApp < PGit::Command::Application
      end

      existent_name = 'existent_name'
      some_other_existent_name = 'some_other_existent_name'
      new_name = 'new_name'
      new_steps = [:no_steps_provided]
      @global_opts, @opts, @args = {}, { 'name' => new_name }, [existent_name]

      fake_steps = ["git fetch origin master",
                    "git push origin :STORY_BRANCH"]
      fake_command_string = double('fake_command_string')
      @new_command = instance_double('PGit::Command', name: new_name, steps: new_steps)
      @fake_command = instance_double('PGit::Command', to_s: fake_command_string, name: existent_name)
      @fake_commands = [@fake_command]
      fake_yaml = double('fake_yaml')
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml)
      @fake_current_project = instance_double('PGit::CurrentProject',
                                              commands: @fake_commands)
      allow(PGit::Configuration).to receive(:new).
        and_return(fake_configuration)
      allow(PGit::CurrentProject).to receive(:new).
        with(fake_configuration).and_return(@fake_current_project)
      allow(PGit::Command).to receive(:new).
        with(existent_name, fake_steps, @fake_current_project).and_return(@fake_command)
      allow(PGit::Command).to receive(:new).
        with(new_name, new_steps, @fake_current_project).and_return(@new_command)


      @app = SomeOtherCommandApp.new(@global_opts, @opts, @args)
      expect(@app.command).to eq @new_command
    end
  end
end


