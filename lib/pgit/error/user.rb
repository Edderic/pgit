module PGit
  class Error
    class User < PGit::Error
      attr_reader :message

      def initialize(message = nil)
        @message = message
        super(@message)
      end
    end
  end
end
