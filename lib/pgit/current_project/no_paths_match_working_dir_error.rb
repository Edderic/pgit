module PGit
  class CurrentProject
    class NoPathsMatchWorkingDirError < PGit::Error
      def initialize
        @message = "None of the project paths matches the working directory"
      end
    end
  end
end
