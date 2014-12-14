module PGit
  class Configuration
    class ProjectMissingError < PGit::Configuration::LayoutError
      def initialize(path)
        @message = prepend_general_message "#{path} needs at least one project."
        super(@message)
      end
    end
  end
end
