module PGit
  class Error
    class External < PGit::Error
      def initialize(message)
        @message = message

        super @message
      end
    end
  end
end
