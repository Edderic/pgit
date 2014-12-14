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

    def initialize(config_path = '~/.pgit.rc.yml')
      @expanded_path = File.expand_path(config_path)
      if File.exists? @expanded_path
        config_file = File.open(@expanded_path, 'r')
        @yaml = YAML.load(config_file)

        validate_existence_of_at_least_one_project
        validate_presence_of_items_in_each_project
      else
        raise PGit::Configuration::NotFoundError.new(@expanded_path)
      end
    end

    def to_yaml
      @yaml
    end

    private

    def validate_presence_of_items_in_each_project
      projects = @yaml["projects"]
      all_present = projects.all? do |project|
        project["api_token"] &&
          project["path"] &&
          project["id"]
      end

      unless all_present
        raise PGit::Configuration::MissingAttributesError.new(@expanded_path)
      end
    end

    def validate_existence_of_at_least_one_project
      unless @yaml["projects"]
        raise PGit::Configuration::ProjectMissingError.new(@expanded_path)

      end
    end
  end
end
