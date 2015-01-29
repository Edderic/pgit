require 'spec_helper'

def fake_config
  fake_project_1 =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                      "id" => 12345,
                      "api_token" => "astoeuh",
                      "commands" => {} }
  fake_project_2 =  { "path" => "~/Therapy-Exercises-Online",
                      "id" => 19191,
                      "api_token" => "astoeuh" }
  fake_project_list = [ fake_project_1, fake_project_2 ]
  fake_yaml = { "projects" => fake_project_list }
  fake_path = "/Therapy-Exercises-Online/some_other_project/some_subdirectory"
  allow(Dir).to receive(:pwd).and_return(fake_path)

  fake_configuration = double('configuration', to_yaml: fake_yaml)
end

describe 'PGit::CurrentProject' do
  describe '#remove(optional)' do
    it 'removes the optional key-value pair' do

      fake_path = "/Therapy-Exercises-Online/some_other_project"
      command_name = 'first_command'
      fake_projects = [
        { "path" => fake_path,
          "id" => 12345,
          "api_token" => "astoeuh",
          "commands" =>
          {
            command_name => ['echo hi', 'echo hello']
          }
        },
        { "path" => "/Therapy-Exercises-Online",
          "id" => 19191,
          "api_token" => "astoeuh" }
      ]

      fake_modified_projects = [
        { "path" => "/Therapy-Exercises-Online/some_other_project",
          "id" => 12345,
          "api_token" => "astoeuh",
          "commands" => {}
        },
        { "path" => "/Therapy-Exercises-Online",
          "id" => 19191,
          "api_token" => "astoeuh" }
      ]
      fake_yaml = { 'projects' => fake_projects }
      fake_command_hash = fake_modified_projects.first["commands"]
      fake_save = { 'commands' => fake_command_hash }
      fake_command = instance_double('PGit::Command',
                                     to_save: fake_save,
                                     project_key: 'commands',
                                     name: command_name)
      fake_configuration = instance_double('PGit::Configuration',
                                           save: nil,
                                           'projects='.to_sym => fake_modified_projects,
                                           projects: fake_projects,
                                           to_yaml: fake_yaml)
      allow(Dir).to receive(:pwd).and_return(fake_path)
      current_project = PGit::CurrentProject.new(fake_configuration)
      current_project.remove!(fake_command)

      expect(fake_configuration).to have_received(:projects=).with(fake_modified_projects)
    end
  end

  describe '#save(saveable)' do
    it 'merges the passed-in command hash in place' do
      fake_projects = [
        { "path" => "/Therapy-Exercises-Online/some_other_project",
          "id" => 12345,
          "api_token" => "astoeuh",
        },
        { "path" => "/Therapy-Exercises-Online",
          "id" => 19191,
          "api_token" => "astoeuh" }
      ]

      fake_modified_projects = [
        { "path" => "/Therapy-Exercises-Online/some_other_project",
          "id" => 12345,
          "api_token" => "astoeuh",
          "commands" =>
          {
            "first_command" => ['echo hi', 'echo hello']
          }
        },
        { "path" => "/Therapy-Exercises-Online",
          "id" => 19191,
          "api_token" => "astoeuh" }
      ]

      fake_command_hash = fake_modified_projects.first["commands"]
      fake_save = { 'commands' => fake_command_hash }
      fake_command = instance_double('PGit::Command', to_save: fake_save)
      fake_yaml = fake_config.to_yaml
      fake_configuration = instance_double('PGit::Configuration',
                                           save: nil,
                                           'projects='.to_sym => fake_modified_projects,
                                           projects: fake_projects,
                                           to_yaml: fake_yaml)

      current_project = PGit::CurrentProject.new(fake_configuration)
      current_project.save(fake_command)

      expect(fake_configuration).to have_received(:projects=).with(fake_modified_projects)
      expect(fake_configuration).to have_received(:save)
    end
  end

  describe '#commands=()' do
    it 'should set the commands' do
      current_project = PGit::CurrentProject.new(fake_config)
      new_command_hash = {'some_command' => ['step1', 'step2']}
      current_project.commands = new_command_hash

      expect(current_project.commands).to eq new_command_hash
    end
  end

  describe '#to_hash' do
    it 'returns the hash version' do
      expected_hash = { "path" => "/Therapy-Exercises-Online/some_other_project",
                      "id" => 12345,
                      "api_token" => "astoeuh",
                      "commands" => {} }

      current_project = PGit::CurrentProject.new(fake_config)

      expect(current_project.to_hash).to eq(expected_hash)
    end
  end

  describe '#to_h' do
    it 'returns the hash version' do
      current_project = PGit::CurrentProject.new(fake_config)

      expect(current_project.to_h).to eq(fake_config.to_yaml.fetch("projects").first)
    end
  end

  describe '#path' do
    describe 'more than one of the projects listed matches the working directory' do
      it "should return the more specific directory" do
        current_project = PGit::CurrentProject.new(fake_config)
        working_directory = current_project.path

        expect(working_directory).to eq "/Therapy-Exercises-Online/some_other_project"
      end
    end
  end

  describe '#id' do
    it 'should return the correct pivotal tracker project_id' do
      current_project = PGit::CurrentProject.new(fake_config)
      project_id = current_project.id

      expect(project_id).to eq 12345
    end
  end

  describe '#api_token' do
    it 'should return the api_token associated to the current project' do
      current_project = PGit::CurrentProject.new(fake_config)
      api_token = current_project.api_token

      expect(api_token).to eq 'astoeuh'
    end
  end

  describe '#commands' do
    it 'should return a list of commands if there are any' do
      fake_project_1 =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                          "id" => 12345,
                          "api_token" => "astoeuh",
                          "commands" => {
                            "finish"=>["git push origin master",
                                       "hello"],
                                       "start"=>["lol"]
                          }
      }
      fake_project_2 =  { "path" => "~/Therapy-Exercises-Online",
                          "id" => 19191,
                          "api_token" => "astoeuh" }
      fake_project_list = [ fake_project_1, fake_project_2 ]
      fake_yaml = { "projects" => fake_project_list }
      fake_path = "/Therapy-Exercises-Online/some_other_project/some_subdirectory"
      allow(Dir).to receive(:pwd).and_return(fake_path)
      fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_yaml)
      current_project = PGit::CurrentProject.new(fake_configuration)

      commands = current_project.commands

      expect(commands).to eq fake_project_1["commands"]
    end

    it 'should return an empty hash if there are no commands' do
      current_project = PGit::CurrentProject.new(fake_config)

      expect(current_project.commands).to eq Hash.new
    end
  end
end
