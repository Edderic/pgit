require 'spec_helper'

def successful_setup
  fake_project_1 =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                      "id" => 12345,
                      "api_token" => "astoeuh" }
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
  describe '#new(config_yaml)' do
    it 'should delegate to PGit::CurrentProject::Validator' do
      fake_project_1 =  { "path" => "~/some-non-matching-path",
                          "id" => 12345,
                          "api_token" => "astoeuh" }
      fake_project_2 =  { "path" => "~/some-other-non-matching-path",
                          "id" => 19191,
                          "api_token" => "astoeuh" }
      fake_project_list = [ fake_project_1, fake_project_2 ]
      fake_yaml = { "projects" => fake_project_list }
      fake_path = "/Therapy-Exercises-Online/some_other_project/some_subdirectory"
      fake_configuration = double('configuration', to_yaml: fake_yaml)
      allow(Dir).to receive(:pwd).and_return(fake_path)
      allow(PGit::CurrentProject::Validator).to receive(:new).with([]).and_raise 'some_error'

      expect{ PGit::CurrentProject.new(fake_configuration.to_yaml) }.to raise_error 'some_error'
    end
  end

  describe '#save' do
    it 'should save the current project' do
      fake_configuration = instance_double('PGit::Configuration')

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

      allow(Dir).to receive(:pwd).and_return("/Therapy-Exercises-Online/some_other_project")

      fake_yaml = successful_setup.to_yaml
      allow(fake_configuration).to receive(:projects=).with(fake_modified_projects)
      allow(fake_configuration).to receive(:projects).and_return(fake_projects)
      allow(fake_configuration).to receive(:save)
      allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)

      current_project = PGit::CurrentProject.new(fake_yaml)
      current_project.commands = { "first_command" => ['echo hi', 'echo hello'] }
      current_project.save

      expect(fake_configuration).to have_received(:projects=).with(fake_modified_projects)
      expect(fake_configuration).to have_received(:save)
    end
  end

  describe '#commands=()' do
    it 'should set the commands' do
      yaml = successful_setup.to_yaml
      current_project = PGit::CurrentProject.new(yaml)
      new_command_hash = {'some_command' => ['step1', 'step2']}
      current_project.commands = new_command_hash

      expect(current_project.commands).to eq new_command_hash
    end
  end

  describe '#to_hash' do
    it 'returns the hash version' do
      fake_config_hash =
        {
        "projects" =>
        [
          { "api_token" => "hello1234",
            "path" => "~/some/path",
            "id" => "12345678",
            "commands" =>
            [
              {
                "start" =>
                [
                  "step1",
                  "step2"
                ]
              }
            ]
        }
        ]
      }
        expected_hash =
          { "api_token" => "hello1234",
            "path" => "~/some/path",
            "id" => "12345678",
            "commands" =>
        [
          {
            "start" =>
            [
              "step1",
              "step2"
            ]
          }
        ]
        }

          allow(File).to receive(:expand_path).and_return("/Users/Edderic/some/path")
          allow(File).to receive(:expand_path).with("~/some/path").and_return("/Users/Edderic/some/path")
          allow(Dir).to receive(:pwd).and_return("/Users/Edderic/some/path")
          current_project = PGit::CurrentProject.new(fake_config_hash)

          expect(current_project.to_hash).to eq(expected_hash)
    end
  end

  describe '#to_h' do
    it 'returns the hash version' do
      fake_config_hash =
        {
        "projects" =>
        [
          { "api_token" => "hello1234",
            "path" => "~/some/path",
            "id" => "12345678",
            "commands" =>
            [
              {
                "start" =>
                [
                  "step1",
                  "step2"
                ]
              }
            ]
        }
        ]
      }
        expected_hash =
          { "api_token" => "hello1234",
            "path" => "~/some/path",
            "id" => "12345678",
            "commands" =>
        [
          {
            "start" =>
            [
              "step1",
              "step2"
            ]
          }
        ]
        }

          allow(File).to receive(:expand_path).and_return("/Users/Edderic/some/path")
          allow(File).to receive(:expand_path).with("~/some/path").and_return("/Users/Edderic/some/path")
          allow(Dir).to receive(:pwd).and_return("/Users/Edderic/some/path")
          current_project = PGit::CurrentProject.new(fake_config_hash)

          expect(current_project.to_h).to eq(expected_hash)
    end
  end

  describe '#path' do
    describe 'more than one of the projects listed matches the working directory' do
      it "should return the more specific directory" do
        fake_configuration = successful_setup

        current_project = PGit::CurrentProject.new(fake_configuration.to_yaml)
        working_directory = current_project.path

        expect(working_directory).to eq "/Therapy-Exercises-Online/some_other_project"
      end
    end
  end

  describe '#id' do
    it 'should return the correct pivotal tracker project_id' do
      fake_configuration = successful_setup

      current_project = PGit::CurrentProject.new(fake_configuration.to_yaml)
      project_id = current_project.id

      expect(project_id).to eq 12345
    end
  end

  describe '#api_token' do
    it 'should return the api_token associated to the current project' do
      fake_configuration = successful_setup

      current_project = PGit::CurrentProject.new(fake_configuration.to_yaml)
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

      current_project = PGit::CurrentProject.new(fake_yaml)

      commands = current_project.commands

      expect(commands).to eq fake_project_1["commands"]
    end

    it 'should return an empty hash if there are no commands' do
      fake_configuration = successful_setup

      current_project = PGit::CurrentProject.new(fake_configuration.to_yaml)

      expect(current_project.commands).to eq Hash.new
    end
  end
end
