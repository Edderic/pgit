require_relative '../lib/pivotal'

describe 'PGit::Configuration' do
  describe '#new(configuration_path)' do
    describe 'empty' do
      it 'should complain that there should be at least one project' do
        fake_path = "~/some/config/path.yml"
        fake_expanded_path = "/Users/edderic/some/config/path.yml"
        fake_file = double('file')
        fake_yaml = {}

        allow(File).to receive(:expand_path).with(fake_path).and_return(fake_expanded_path)
        allow(File).to receive(:expand_path).with('.')
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)
        error_message =  "Error: #{fake_expanded_path} needs at least one project.\n" +
                         "Please have the following layout:\n" +
                         "\n" +
                         "projects:\n" +
                         "  - path: ~/some/path/to/a/pivotal-git/project\n" +
                         "    id: 12345\n" +
                         "    api_token: somepivotalatoken124"

        expect{ PGit::Configuration.new(fake_path) }.to raise_error(error_message)
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
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)
        error_message =  "Error: Must have a path, id, and api_token for each project.\n" +
                         "Please have the following layout:\n" +
                         "\n" +
                         "projects:\n" +
                         "  - path: ~/some/path/to/a/pivotal-git/project\n" +
                         "    id: 12345\n" +
                         "    api_token: somepivotalatoken124"

        expect{ PGit::Configuration.new(fake_path) }.to raise_error(error_message)
      end
    end
  end

  describe '#new(configuration_path)' do
    describe 'configuration_path exists' do
      it '#to_yaml should return the yaml file' do
        fake_path = "~/some/config/path.yml"
        fake_expanded_path = "/Users/edderic/some/config/path.yml"
        fake_file = double('file')
        fake_projects = [ { "path" => 'fake_path',
                            "id" =>   'fake_id',
                            "api_token" => 'fake_token'
                          }]

        fake_yaml = { 'projects' => fake_projects }

        allow(File).to receive(:expand_path).with(fake_path).and_return(fake_expanded_path)
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)

        configuration = PGit::Configuration.new(fake_path)

        expect(configuration.to_yaml).to eq fake_yaml
      end
    end

    describe 'configuration path does not exist' do
      it 'should throw an error' do
        file_path = '~/.edderic-dotfiles/config/project.yml'
        fake_expanded_path = "/home/edderic/.edderic-dotfiles/config/project.yml"
        error_message = "No such file or directory. Please give a valid path to the project.yml"
        allow(File).to receive(:exists?).and_return(false)

        expect{ PGit::Configuration.new(file_path) }.to raise_error
      end
    end
  end

  describe '#new (without any arguments)' do
    describe 'default configuration_path does exist' do
      it 'should load the default configuration file' do
        default_path = "~/.edderic-dotfiles/config/pivotal.yml"
        default_expanded_path = "/Users/edderic/.edderic-dotfiles/config/pivotal.yml"
        fake_file = double('file')

        fake_projects = [ { "path" => 'fake_path',
                            "id" =>   'fake_id',
                            "api_token" => 'fake_token'
                          }]

        fake_yaml = { 'projects' => fake_projects }

        allow(File).to receive(:expand_path).with(default_path).and_return(default_expanded_path)
        allow(File).to receive(:open).with(default_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)

        configuration = PGit::Configuration.new

        expect(File).to have_received(:expand_path).with(default_path)
      end
    end
  end
end
