module PGit
  class Command
    class EmptyError < PGit::Error
      def initialize
        @message = "No commands are listed for this project. Run `pgit command add --help` for more info."
        super @message
      end
    end
  end
end
