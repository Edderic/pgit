module PGit
  class Configuration
    class NotFoundError < PGit::Error
      def initialize
        @message = %w[Default configuration file does not exist. Please run `pgit
              install`].join(' ')
        super(@message)
      end
    end
  end
end
