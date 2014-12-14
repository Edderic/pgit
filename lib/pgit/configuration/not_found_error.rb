module PGit
  class Configuration
    class NotFoundError < PGit::Error
      def initialize(config_path)
        @message = "#{config_path} configuration file does not exist. Please run `pgit install`"
        super(@message)
      end
    end
  end
end
