require 'spec_helper'
require 'byebug'

describe 'PGit::Project' do
  describe '#commands=' do
    it 'sets the commands' do
      command = instance_double('PGit::Command')
      command_name = 'command_name'
      command_steps = ['subcommand1', 'subcommand2']
      new_command = instance_double('PGit::Command', name: command_name,
                                                     steps: command_steps)
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [{'command_name' => command_steps }] }
      some_other_proj = instance_double('PGit::Project')
      allow(PGit::Command).to receive(:new).and_return(command)
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)
      proj.commands = [new_command]

      expect(proj.commands.first).to eq new_command
    end
  end

  describe '#commands' do
    it 'returns the commands if they exist' do
      command = instance_double('PGit::Command')
      command_name = 'command_name'
      command_steps = ['subcommand1', 'subcommand2']
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [{'command_name' => command_steps }] }
      allow(PGit::Command).to receive(:new).and_return(command)
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj.commands.first).to eq command
    end

    it 'returns empty array if there are no commands' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj.commands).to eq []
    end
  end

  describe '#path' do
    it 'returns the path' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)
      expect(proj.path).to eq project_hash.fetch('path')
    end

    it 'defaults to Dir.pwd' do
      configuration = instance_double('PGit::Configuration')
      fake_path = double('path')
      api_token = 's3cret'
      id = 12345
      allow(Dir).to receive(:pwd).and_return(fake_path)
      proj = PGit::Project.new(configuration) do |p|
        p["api_token"] = api_token
        p["id"] = id
      end

      expect(proj.path).to eq fake_path
    end
  end

  describe '#api_token' do
    it 'returns the api_token' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)
      expect(proj.api_token).to eq project_hash.fetch('api_token')
    end
  end

  describe '#id' do
    it 'returns the id' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)
      expect(proj.id).to eq project_hash.fetch('id')
    end
  end

  describe '#has_path?(path)' do
    it 'returns true if the paths are the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj).to be_has_path(project_hash.fetch('path'))
    end

    it 'returns false if the paths are not the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj).not_to be_has_path('some/other/path')
    end
  end

  describe '#has_api_token?(api_token)' do
    it 'returns true if the api_tokens are the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj).to be_has_api_token(project_hash.fetch('api_token'))
    end

    it 'returns false if the api_tokens are not the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj).not_to be_has_api_token('some/other/api_token')
    end
  end

  describe '#has_id?(id)' do
    it 'returns true if the ids are the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj).to be_has_id(project_hash.fetch('id'))
    end

    it 'returns false if the ids are not the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj).not_to be_has_id(54321)
    end
  end

  describe 'instatiating with a block' do
    it 'sets the api_token, path, id based on the block' do
      path = '/some/path'
      api_token = 's3cret'
      id = 12345
      commands = []
      configuration = instance_double('PGit::Configuration')

      proj = PGit::Project.new(configuration) do |p|
        p["path"] = path
        p["api_token"] = api_token
        p["id"] = id
        p["commands"] = commands
      end

      expect(proj.path).to eq path
      expect(proj.api_token).to eq api_token
      expect(proj.id).to eq id
      expect(proj.commands).to eq commands
    end
  end

  describe '#to_hash' do
    it 'returns the hash version' do
      command = "command1"
      steps = ["step1", "step2"]
      command_hash = { command => steps }
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [
                          command_hash
                        ]
                      }
      fake_command = instance_double('PGit::Command', to_hash: command_hash)
      configuration = instance_double('PGit::Configuration')
      proj = PGit::Project.new(configuration, project_hash)

      expect(proj.to_hash).to eq project_hash
    end
  end

  describe '#save!' do
    it 'saves the project if does not exist' do
      projects = []
      configuration = instance_double('PGit::Configuration',
                                      projects: projects,
                                      "projects=".to_sym => :success,
                                      save!: :successful_save)
      command = "command1"
      steps = ["step1", "step2"]
      command_hash = { command => steps }
      new_project = instance_double('PGit::Project',
                                    'path'=>"/Therapy-Exercises-Online/some_other_project",
                                    'id'=> 54321,
                                    'api_token'=> 'astoeuh',
                                    'commands'=> [command_hash])

      new_projs = [new_project]
      allow(configuration).to receive(:projects=).with(new_projs)

      proj = PGit::Project.new(configuration) do |p|
        p["path"] = new_project.path
        p["api_token"] = new_project.api_token
        p["id"] = 54321
      end

      proj.save!

      expect(configuration).to have_received(:save!)
      expect(configuration.projects.first.path).to eq proj.path
      expect(configuration.projects.first.id).to eq 54321
      expect(configuration.projects.size).to eq 1
    end

    it 'replaces the old copy of the project' do
      command = "command1"
      steps = ["step1", "step2"]
      command_hash = { command => steps }
      old_project = instance_double('PGit::Project',
                                    'path'=>"/Therapy-Exercises-Online/some_other_project",
                                    'id'=> 12345,
                                    'api_token'=> 'astoeuh',
                                    'commands'=> [command_hash])
      new_project = instance_double('PGit::Project',
                                    'path'=>"/Therapy-Exercises-Online/some_other_project",
                                    'id'=> 54321,
                                    'api_token'=> 'astoeuh',
                                    'commands'=> [command_hash])

      projects = [old_project]

      class SomeConfig
        def initialize(fake_proj)
          @projs = [] << fake_proj
        end

        def projects
          @projs
        end

        def projects=(projArr)
          @projs = projArr
        end

        def save!
        end
      end

      configuration = SomeConfig.new(old_project)
      allow(configuration).to receive(:save!)

      proj = PGit::Project.new(configuration) do |p|
        p["path"] = old_project.path
        p["api_token"] = old_project.api_token
        p["id"] = 54321
      end

      proj.save!

      expect(configuration).to have_received(:save!)
      expect(configuration.projects.first.path).to eq proj.path
      expect(configuration.projects.first.id).to eq 54321
      expect(configuration.projects.size).to eq 1
    end

    it 'raises an error if id does not exist' do
      command = "command1"
      steps = ["step1", "step2"]
      command_hash = { command => steps }
      old_project = instance_double('PGit::Project',
                                    'path'=>"/Therapy-Exercises-Online/some_other_project",
                                    'id'=> 12345,
                                    'api_token'=> 'astoeuh',
                                    'commands'=> [command_hash])
      new_project = instance_double('PGit::Project',
                                    'path'=>"/Therapy-Exercises-Online/some_other_project",
                                    'id'=> 54321,
                                    'api_token'=> 'astoeuh',
                                    'commands'=> [command_hash])

      projects = [old_project]
      configuration = instance_double('PGit::Configuration',
                                      projects: projects,
                                      "projects=".to_sym => :success,
                                      save!: :successful_save)

      new_projs = [new_project]
      allow(configuration).to receive(:projects=).with(new_projs)

      proj = PGit::Project.new(configuration) do |p|
        p["path"] = old_project.path
        p["api_token"] = old_project.api_token
      end

      expect{proj.save!}.to raise_error(PGit::Error::User, :no_id_provided)
    end

    it 'raises an error if api_token does not exist' do
      command = "command1"
      steps = ["step1", "step2"]
      command_hash = { command => steps }
      old_project = instance_double('PGit::Project',
                                    'path'=>"/Therapy-Exercises-Online/some_other_project",
                                    'id'=> 12345,
                                    'api_token'=> 'astoeuh',
                                    'commands'=> [command_hash])
      new_project = instance_double('PGit::Project',
                                    'path'=>"/Therapy-Exercises-Online/some_other_project",
                                    'id'=> 54321,
                                    'api_token'=> 'astoeuh',
                                    'commands'=> [command_hash])

      projects = [old_project]
      configuration = instance_double('PGit::Configuration',
                                      projects: projects,
                                      "projects=".to_sym => :success,
                                      save!: :successful_save)

      new_projs = [new_project]
      allow(configuration).to receive(:projects=).with(new_projs)

      proj = PGit::Project.new(configuration) do |p|
        p["path"] = old_project.path
        p["id"] = old_project.id
      end

      expect{proj.save!}.to raise_error(PGit::Error::User, :no_api_token_provided)
    end
  end

  describe '#remove!' do
    it 'removes the project' do
      matching_path = "/Therapy-Exercises-Online/some_other_project"
      project_hash =  { "path" => matching_path,
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => [] }
      project = instance_double('PGit::Project', path: matching_path)

      class SomeConfig
        def initialize(fake_proj)
          @projs = [] << fake_proj
        end

        def projects
          @projs
        end

        def projects=(projArr)
          @projs = projArr
        end

        def save!
        end
      end

      configuration = SomeConfig.new(project)
      allow(configuration).to receive(:save!)
      proj = PGit::Project.new(configuration, project_hash)

      proj.remove!

      expect(configuration.projects.size).to eq 0
    end
  end

  describe '#exists?' do
    it 'returns true if it is already in the configuration' do
      matching_path = "/Therapy-Exercises-Online/some_other_project"
      project = instance_double('PGit::Project', path: matching_path)
      projects = [project]
      configuration = instance_double('PGit::Configuration',
                                      projects: projects,
                                      save!: true)
      proj = PGit::Project.new(configuration) do |p|
        p["path"] = matching_path
      end

      expect(proj).to be_exists
    end

    it 'returns false if it is not in the configuration' do
      matching_path = "/Therapy-Exercises-Online/some_other_project"
      project = instance_double('PGit::Project', path: matching_path)
      projects = [project]
      configuration = instance_double('PGit::Configuration',
                                      projects: projects,
                                      save!: true)
      proj = PGit::Project.new(configuration) do |p|
        p["path"] = '/some/non-matching/path'
      end

      expect(proj).not_to be_exists
    end
  end
end
