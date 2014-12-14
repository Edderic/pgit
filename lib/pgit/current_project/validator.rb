module PGit
  class CurrentProject
    class Validator
      def initialize(matching_projects)
        if matching_projects.length == 0
          raise PGit::CurrentProject::NoPathsMatchWorkingDirError.new
        end
      end
    end
  end
end
