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

  describe '#yaml' do
    it 'defaults to empty hash if configuration does not exist' do
      expanded_path = "/some/path/to/.pgit.rc.yml"
      config_path = '~/.pgit.rc.yml'
      allow(File).to receive(:expand_path).with(config_path).and_return(expanded_path)
      file = instance_double('File', close: nil)
      allow(File).to receive(:new).with(expanded_path, 'w').and_return(file)
      allow(YAML).to receive(:load_file).with(expanded_path).and_return(false)

      configuration = PGit::Configuration.new

      expect(configuration.yaml).to eq Hash.new
    end
  end

  describe '#to_hash' do
    it 'returns the hash' do
      fake_validator = instance_double('PGit::Configuration::Validator')
      hash = { "projects" => [] }
      allow(fake_validator).to receive(:yaml).and_return(hash)
      expanded_path = "/some/path/to/.pgit.rc.yml"
      config_path = '~/.pgit.rc.yml'
      allow(File).to receive(:expand_path).with(config_path).and_return(expanded_path)
      file = instance_double('File', close: nil)
      allow(File).to receive(:new).with(expanded_path, 'w').and_return(file)
      allow(YAML).to receive(:load_file).with(expanded_path).and_return(hash)

      configuration = PGit::Configuration.new

      expect(configuration.to_hash).to eq hash
    end
  end

  describe '#projects' do
    it 'returns the projects' do
      proj1 = instance_double('PGit::Project')
      proj2 = instance_double('PGit::Project')
      proj_hash1 = instance_double('Hash')
      proj_hash2 = instance_double('Hash')
      expanded_path = "/some/path/to/.pgit.rc.yml"
      projects = [proj1, proj2]
      project_hashes = [proj_hash1, proj_hash2]
      yaml = { 'projects' => project_hashes }

      config_path = '~/.pgit.rc.yml'
      allow(File).to receive(:expand_path).with(config_path).and_return(expanded_path)
      file = instance_double('File', close: nil)
      allow(File).to receive(:new).with(expanded_path, 'w').and_return(file)

      allow(YAML).to receive(:load_file).with(expanded_path).and_return(yaml)

      configuration = PGit::Configuration.new

      allow(PGit::Project).to receive(:new).with(configuration, proj_hash1).and_return(proj1)
      allow(PGit::Project).to receive(:new).with(configuration, proj_hash2).and_return(proj2)

      expect(configuration.projects).to eq projects
    end
  end

  describe '#projects=(some projects)' do
    it 'should set the projects' do
      proj_hash1 = instance_double('Hash')
      proj_hash2 = instance_double('Hash')
      proj1 = instance_double('PGit::Project', path: 'proj1/path', to_hash: proj_hash1)
      proj2 = instance_double('PGit::Project', path: 'proj2/path', to_hash: proj_hash2)
      expanded_path = "/some/path/to/.pgit.rc.yml"
      projects = [proj1, proj2]
      project_hashes = [proj_hash1, proj_hash2]
      yaml = { 'projects' => project_hashes }

      config_path = '~/.pgit.rc.yml'
      allow(File).to receive(:expand_path).with(config_path).and_return(expanded_path)
      file = instance_double('File', close: nil)
      allow(File).to receive(:new).with(expanded_path, 'w').and_return(file)

      allow(YAML).to receive(:load_file).with(expanded_path).and_return(yaml)

      configuration = PGit::Configuration.new

      allow(PGit::Project).to receive(:new).with(configuration, proj_hash1).and_return(proj1)
      allow(PGit::Project).to receive(:new).with(configuration, proj_hash2).and_return(proj2)

      configuration.projects = projects

      expect(configuration.projects.first.path).to eq 'proj1/path'
      expect(configuration.projects[1].path).to eq 'proj2/path'
    end
  end

  describe '#save' do
    it 'should save the configuration to the config path' do
      proj_hash1 = instance_double('Hash')
      proj_hash2 = instance_double('Hash')
      proj1 = instance_double('PGit::Project', to_hash: proj_hash1)
      proj2 = instance_double('PGit::Project', to_hash: proj_hash2)
      expanded_path = "/some/path/to/.pgit.rc.yml"
      projects = [proj1, proj2]
      project_hashes = [proj_hash1, proj_hash2]
      yaml = { 'projects' => project_hashes }

      config_path = '~/.pgit.rc.yml'
      allow(File).to receive(:expand_path).with(config_path).and_return(expanded_path)
      file = instance_double('File', close: nil)
      allow(File).to receive(:new).with(expanded_path, 'w').and_return(file)

      allow(YAML).to receive(:load_file).with(expanded_path).and_return(yaml)
      allow(YAML).to receive(:dump).with(yaml, file).and_return(yaml)

      configuration = PGit::Configuration.new

      allow(PGit::Project).to receive(:new).with(configuration, proj_hash1).and_return(proj1)
      allow(PGit::Project).to receive(:new).with(configuration, proj_hash2).and_return(proj2)

      configuration.projects = projects
      configuration.save!

      expect(YAML).to have_received(:dump).with(yaml, file)
    end
  end
end
