module PGit
  class ExternalError < PGit::Error
    def initialize(message)
      @message = message

      super @message
    end
  end
end
