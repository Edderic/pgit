#
#   Loads the Pivotal-Git configuration file
#
# - config_path is the path to the pivotal-git configuration file
#   This loads the file. Throws an error if a key (such as api_token, path, id)
#   is missing. Check #general_error_message for more info
#

module PGit
  class Configuration
    def initialize(config_path = '~/.edderic-dotfiles/config/pivotal.yml')
      @expanded_path = File.expand_path(config_path)
      config_file = File.open(@expanded_path, 'r')
      @yaml = YAML.load(config_file)

      validate_existence_of_at_least_one_project
      validate_presence_of_items_in_each_project
    end

    def to_yaml
      @yaml
    end

    private

    def general_error_message
      "Please have the following layout:\n" +
        "\n" +
        "projects:\n" +
        "  - path: ~/some/path/to/a/pivotal-git/project\n" +
        "    id: 12345\n" +
        "    api_token: somepivotalatoken124"
    end

    def validate_presence_of_items_in_each_project
      projects = @yaml["projects"]
      all_present = projects.all? do |project|
        project["api_token"] &&
          project["path"] &&
          project["id"]
      end

      unless all_present
        raise "Error: Must have a path, id, and api_token for each project.\n" +
          general_error_message
      end
    end

    def validate_existence_of_at_least_one_project
      unless @yaml["projects"]
        raise "Error: #{@expanded_path} needs at least one project.\n" +
          general_error_message

      end
    end
  end
end
