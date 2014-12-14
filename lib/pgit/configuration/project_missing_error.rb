module PGit
  class Configuration
    class LayoutError < PGit::Error
      def general_message
        "Please have the following layout:\n" + YAML.dump(PGit::Configuration.default_options)
      end
    end

    class ProjectMissingError < LayoutError
      def initialize
        @message =
          "/Users/edderic/some/config/path.yml needs at least one project.\n" +
          general_message
        super(@message)
      end
    end
  end
end
