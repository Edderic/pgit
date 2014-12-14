module PGit
  class Configuration
    class MissingAttributesError < PGit::Configuration::LayoutError
      def initialize(path)
        @message = prepend_general_message "#{path} must have a path, id, and api_token for each project."
        super(@message)
      end
    end
  end
end
