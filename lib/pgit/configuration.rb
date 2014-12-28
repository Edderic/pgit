#
#   Loads the Pivotal-Git configuration file
#
# - config_path is the path to the pivotal-git configuration file
#   This loads the file. Throws an error if a key (such as api_token, path, id)
#   is missing. Check #general_error_message for more info
#

module PGit
  class Configuration
    def self.default_options
      {
        'projects' => [
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
      }
    end

    attr_accessor :yaml
    attr_reader :config_path

    def initialize(config_path = '~/.pgit.rc.yml')
      @config_path = config_path
      @validator = PGit::Configuration::Validator.new(config_path)
      @yaml = @validator.yaml
    end

    def save
      expanded_path = File.expand_path(config_path)
      f = File.open(expanded_path, 'w')
      YAML.dump(yaml, f)
    end

    def to_yaml
      yaml
    end
  end
end
