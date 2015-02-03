require 'spec_helper'

describe 'PGit::Configuration' do
  describe '.default_options' do
    it 'should give us the default options' do
      default_options = PGit::Configuration.default_options
      example_projects = [
        {
          'api_token' => 'somepivotalatoken124',
          'id' => '12345',
          "path" => "~/some/path/to/a/pivotal-git/project"
        },
        {
          'api_token' => 'somepivotalatoken124',
          'id' => '23429070',
          "path" => "~/some/other/pivotal-git/project"
        }
      ]

      expect(default_options['projects']).to match_array(example_projects)
    end
  end

  describe '#new (without any arguments)' do
    it 'should delegate the default path to PGit::Configuration::Validator instance' do
      fake_yaml = {}
      fake_validator = instance_double('PGit::Configuration::Validator', yaml: fake_yaml)
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      PGit::Configuration.new

      expect(PGit::Configuration::Validator).to have_received(:new).with("~/.pgit.rc.yml")
    end
  end

  describe '#new ("~/some/path")' do
    it 'should delegate the path to PGit::Configuration::Validator instance' do
      fake_yaml = {}
      fake_validator = instance_double('PGit::Configuration::Validator', yaml: fake_yaml)
      fake_path = "~/some/path"
      allow(PGit::Configuration::Validator).to receive(:new).with(fake_path).and_return fake_validator
      PGit::Configuration.new(fake_path)

      expect(PGit::Configuration::Validator).to have_received(:new).with(fake_path)
    end
  end

  describe '#yaml' do
    it 'returns the hash' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      fake_yaml = { "projects" => "hash" }
      allow(fake_validator).to receive(:yaml).and_return(fake_yaml)
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      configuration = PGit::Configuration.new
      config_yaml = configuration.yaml

      expect(config_yaml).to eq fake_yaml
    end
  end

  describe '#projects' do
    it 'should return the projects' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      fake_projects = [
        { "path" => "/Therapy-Exercises-Online/some_other_project",
          "id" => 12345,
          "api_token" => "astoeuh" },
          { "path" => "/Therapy-Exercises-Online",
            "id" => 19191,
            "api_token" => "astoeuh" }
      ]
      fake_yaml = { 'projects' => fake_projects }
      allow(fake_validator).to receive(:yaml).and_return(fake_yaml)
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      configuration = PGit::Configuration.new

      expect(configuration.projects).to eq fake_projects
    end
  end

  describe '#projects=(some projects)' do
    it 'should set the projects' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      fake_yaml = { "some" => "hash" }
      allow(fake_validator).to receive(:yaml).and_return(fake_yaml)
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      configuration = PGit::Configuration.new
      fake_projects = [
        { "path" => "/Therapy-Exercises-Online/some_other_project",
          "id" => 12345,
          "api_token" => "astoeuh" },
          { "path" => "/Therapy-Exercises-Online",
            "id" => 19191,
            "api_token" => "astoeuh" }
      ]

      configuration.projects = fake_projects
      config_projects = configuration.projects

      expect(config_projects).to eq fake_projects
    end
  end

  describe '#to_yaml' do
    it 'should delegate #yaml to validator' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      fake_projects = {
        'projects' =>
        [
          { "path" => "/Therapy-Exercises-Online/some_other_project",
            "id" => 12345,
            "api_token" => "astoeuh" },
            { "path" => "/Therapy-Exercises-Online",
              "id" => 19191,
              "api_token" => "astoeuh" }
        ]
      }

      allow(fake_validator).to receive(:yaml).and_return(fake_projects)
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      configuration = PGit::Configuration.new

      configuration.to_yaml

      expect(fake_validator).to have_received(:yaml)
    end
  end

  describe '#save' do
    it 'should save the configuration to the config path' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      original_hash = {
        'projects' => [
          {'key' => 'value'}
        ]
      }

      projects = [
        { 'another' => 'hash' }
      ]
      projects_hash = { "projects" => projects }
      config_file = instance_double('File')
      short_path = "~/.pgit.rc.yml"
      long_path = "/Users/Edderic/.pgit.rc.yml"
      allow(File).to receive(:expand_path).with(short_path).and_return(long_path)
      allow(File).to receive(:open).with(long_path, 'w').and_return(config_file)
      allow(config_file).to receive(:write).with("---\nanother: hash\n")
      allow(config_file).to receive(:close)
      allow(fake_validator).to receive(:yaml).and_return(original_hash)
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      allow(YAML).to receive(:dump).with(projects_hash, config_file)
      configuration = PGit::Configuration.new
      configuration.projects = projects

      configuration.save

      expect(YAML).to have_received(:dump).with(projects_hash, config_file)
    end
  end
end
