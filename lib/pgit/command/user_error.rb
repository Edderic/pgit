module PGit
  class Command
    class UserError < PGit::Error
      attr_reader :message

      def initialize(message)
        @message = message
        super(@message)
      end
    end
  end
end
