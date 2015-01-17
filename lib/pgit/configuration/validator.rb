module PGit
  class Configuration
    class Validator
      attr_reader :yaml

      def initialize(config_path)
        validate_existence_of_configuration(config_path)
        validate_existence_of_at_least_one_project
        validate_presence_of_items_in_each_project
      end

      private

      def validate_existence_of_configuration(config_path)
        @expanded_path = File.expand_path(config_path)
        error_message = "#{@expanded_path} configuration file does not exist. Please run `pgit install`"
        raise PGit::Error::User, error_message unless File.exists? @expanded_path

        config_file = File.open(@expanded_path, 'r')
        @yaml = YAML.load(config_file)
      end

      def validate_presence_of_items_in_each_project
        projects = @yaml["projects"]
        all_present = projects.all? do |project|
          project["api_token"] &&
            project["path"] &&
            project["id"]
        end

        unless all_present
          message = "#{@expanded_path} must have a path, id, and api_token for " +
                    "each project.\nPlease have the following layout:\n" +
                    YAML.dump(PGit::Configuration.default_options)

          raise PGit::Error::User, message
        end
      end

      def validate_existence_of_at_least_one_project
        unless @yaml["projects"]
          message = "#{@expanded_path} must have at least one project.\n" +
                    "Please have the following layout:\n" +
                    YAML.dump(PGit::Configuration.default_options)

          raise PGit::Error::User, message
        end
      end
    end
  end
end
