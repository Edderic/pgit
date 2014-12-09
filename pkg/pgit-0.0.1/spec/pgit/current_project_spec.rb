require 'pgit'
# .edderic-dotfiles/config.yml
# projects
#   - path:                  ~/Therapy-Exercises-Online
#     id:                    12345
#     api_token: asoeuhot
#
def successful_setup
  fake_project_1 =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                      "id" => 12345,
                      "api_token" => "astoeuh" }
  fake_project_2 =  { "path" => "/Therapy-Exercises-Online",
                      "id" => 19191,
                      "api_token" => "astoeuh" }
  fake_project_list = [ fake_project_1, fake_project_2 ]
  fake_yaml = { "projects" => fake_project_list }
  fake_pwd = "/Therapy-Exercises-Online/some_other_project/some_subdirectory"
  allow(Dir).to receive(:pwd).and_return(fake_pwd)

  fake_configuration = double('configuration', to_yaml: fake_yaml)
end

describe 'PGit::CurrentProject' do
  describe '#new(config_yaml)' do
    describe 'none of the projects listed matches the working directory' do
      it 'should throw an error' do
        error_message = "None of the project paths matches the working directory"
        fake_project_1 =  { "path" => "~/some-non-matching-path",
                            "id" => 12345,
                            "api_token" => "astoeuh" }
        fake_project_2 =  { "path" => "~/some-other-non-matching-path",
                            "id" => 19191,
                            "api_token" => "astoeuh" }
        fake_project_list = [ fake_project_1, fake_project_2 ]
        fake_yaml = { "projects" => fake_project_list }
        fake_pwd = "/Therapy-Exercises-Online/some_other_project/some_subdirectory"
        fake_configuration = double('configuration', to_yaml: fake_yaml)
        allow(Dir).to receive(:pwd).and_return(fake_pwd)

        expect{ PGit::CurrentProject.new(fake_configuration.to_yaml) }.to raise_error(error_message)
      end
    end

  end

  describe '#pwd' do
    describe 'more than one of the projects listed matches the working directory' do
      it "should return the more specific directory" do
        fake_configuration = successful_setup

        current_project = PGit::CurrentProject.new(fake_configuration.to_yaml)
        working_directory = current_project.pwd

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
end