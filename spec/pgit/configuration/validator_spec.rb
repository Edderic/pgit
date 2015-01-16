require 'spec_helper'

describe 'PGit::Configuration::Validator' do
  describe '#new(configuration_path)' do
    describe 'empty file' do
      it 'should complain that there should be at least one project' do
        fake_path = "~/some/config/path.yml"
        fake_expanded_path = "/Users/edderic/some/config/path.yml"
        fake_file = double('file')
        fake_yaml = {}

        allow(File).to receive(:expand_path).with(fake_path).and_return(fake_expanded_path)
        allow(File).to receive(:expand_path).with('.')
        allow(File).to receive(:exists?).with(fake_expanded_path).and_return(true)
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)
        allow(YAML).to receive(:dump).and_return("FAKE_YAML_CONFIGURATION")

        error_message = "#{fake_expanded_path} must have at least one project.\n" +
                  "Please have the following layout:\nFAKE_YAML_CONFIGURATION"
        expect do
          PGit::Configuration::Validator.new(fake_path)
        end.to raise_error(PGit::UserError, error_message)
      end
    end

    describe 'has projects but is missing a token' do
      it 'should raise an error' do
        fake_path = "~/some/config/path.yml"
        fake_expanded_path = "/Users/edderic/some/config/path.yml"
        fake_file = double('file')
        fake_projects = [ { path: 'fake_path',
                            api_token: 'fake_token'
                          }]
        fake_yaml = { 'projects' => fake_projects }

        allow(File).to receive(:expand_path).with(fake_path).and_return(fake_expanded_path)
        allow(File).to receive(:expand_path).with('.')
        allow(File).to receive(:exists?).with(fake_expanded_path).and_return(true)
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)
        allow(YAML).to receive(:dump).and_return("FAKE_YAML_CONFIGURATION")

        error_message = "#{fake_expanded_path} must have a path, id, and api_token for each project.\nPlease have the following layout:\nFAKE_YAML_CONFIGURATION"

        expect do
          PGit::Configuration::Validator.new(fake_path)
        end.to raise_error(PGit::UserError, error_message)
      end
    end

    describe 'configuration_path exists' do
      it '#yaml should return the yaml file' do
        fake_path = "~/some/config/path.yml"
        fake_expanded_path = "/Users/edderic/some/config/path.yml"
        fake_file = double('file')
        fake_projects = [ { "path" => 'fake_path',
                            "id" =>   'fake_id',
                            "api_token" => 'fake_token'
                          }]

        fake_yaml = { 'projects' => fake_projects }

        allow(File).to receive(:expand_path).with(fake_path).and_return(fake_expanded_path)
        allow(File).to receive(:exists?).with(fake_expanded_path).and_return(true)
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)

        configuration = PGit::Configuration::Validator.new(fake_path)

        expect(configuration.yaml).to eq fake_yaml
      end
    end

    describe 'configuration path does not exist' do
      it 'should throw an error' do
        file_path = '~/.edderic-dotfiles/config/project.yml'
        fake_expanded_path = "/home/edderic/.edderic-dotfiles/config/project.yml"
        allow(File).to receive(:exists?).and_return(false)

        expect{ PGit::Configuration::Validator.new(file_path) }.to raise_error(PGit::Configuration::NotFoundError)
      end
    end
  end
end
