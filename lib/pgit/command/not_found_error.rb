module PGit
  class Command
    class NotFoundError < PGit::Error
      attr_reader :message
      def initialize(message)
        @message = "Command '#{message}' does not exist. Run 'pgit command --list' to see the available custom commands."
        super @message
      end
    end
  end
end
