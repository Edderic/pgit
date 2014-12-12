require 'pgit'

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
  describe '#new(configuration_path)' do
    describe 'empty' do
      it 'should complain that there should be at least one project' do
        fake_path = "~/some/config/path.yml"
        fake_expanded_path = "/Users/edderic/some/config/path.yml"
        fake_file = double('file')
        fake_yaml = {}
        error_message = <<-ERROR
          Error: /Users/edderic/some/config/path.yml needs at least one project.
          Please have the following layout:
          ---
          projects:
          - api_token: somepivotalatoken124
            id: '12345'
            path: "~/some/path/to/a/pivotal-git/project"
          - api_token: somepivotalatoken124
            id: '23429070'
            path: "~/some/other/pivotal-git/project"
        ERROR

        allow(File).to receive(:expand_path).with(fake_path).and_return(fake_expanded_path)
        allow(File).to receive(:expand_path).with('.')
        allow(File).to receive(:exists?).with(fake_expanded_path).and_return(true)
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)
        error_message.gsub!(/^\s{10}/,'')

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
        allow(File).to receive(:exists?).with(fake_expanded_path).and_return(true)
        allow(File).to receive(:open).with(fake_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)
        error_message = <<-ERROR
          Error: Must have a path, id, and api_token for each project.
          Please have the following layout:
          ---
          projects:
          - api_token: somepivotalatoken124
            id: '12345'
            path: "~/some/path/to/a/pivotal-git/project"
          - api_token: somepivotalatoken124
            id: '23429070'
            path: "~/some/other/pivotal-git/project"
        ERROR
        error_message.gsub!(/^\s{10}/, '')

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
        allow(File).to receive(:exists?).with(fake_expanded_path).and_return(true)
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
        default_path = "~/.pgit.rc.yml"
        default_expanded_path = "/Users/edderic/.pgit.rc.yml"
        fake_file = double('file')

        fake_projects = [ { "path" => 'fake_path',
                            "id" =>   'fake_id',
                            "api_token" => 'fake_token'
                          }]

        fake_yaml = { 'projects' => fake_projects }

        allow(File).to receive(:exists?).with(default_expanded_path).and_return(true)
        allow(File).to receive(:expand_path).with(default_path).and_return(default_expanded_path)
        allow(File).to receive(:open).with(default_expanded_path, 'r').and_return(fake_file)
        allow(YAML).to receive(:load).with(fake_file).and_return(fake_yaml)

        configuration = PGit::Configuration.new

        expect(File).to have_received(:expand_path).with(default_path)
      end
    end

    describe 'default configuration file does not exist' do
      it 'should throw an error' do
        allow(File).to receive(:exists?).and_return(false)

        error_message =  "Default configuration file does not exist. Please run `pgit install`"
        expect{ PGit::Configuration.new }.to raise_error(error_message)
      end
    end
  end
end
