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
      fake_validator = instance_double('PGit::Configuration::Validator')
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      PGit::Configuration.new

      expect(PGit::Configuration::Validator).to have_received(:new).with("~/.pgit.rc.yml")
    end
  end

  describe '#new ("~/some/path")' do
    it 'should delegate the path to PGit::Configuration::Validator instance' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      fake_path = "~/some/path"
      allow(PGit::Configuration::Validator).to receive(:new).with(fake_path).and_return fake_validator
      PGit::Configuration.new(fake_path)

      expect(PGit::Configuration::Validator).to have_received(:new).with(fake_path)
    end
  end

  describe '#to_yaml' do
    it 'should delegate #yaml to validator' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      allow(fake_validator).to receive(:yaml)
      allow(PGit::Configuration::Validator).to receive(:new).with("~/.pgit.rc.yml").and_return fake_validator
      configuration = PGit::Configuration.new
      configuration.to_yaml

      expect(fake_validator).to have_received(:yaml)
    end
  end
end
