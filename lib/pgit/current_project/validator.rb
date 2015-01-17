module PGit
  class CurrentProject
    class Validator
      def initialize(matching_projects)
        if matching_projects.length == 0
          message = "None of the project paths matches the working directory"
          raise PGit::Error::User, message
        end
      end
    end
  end
end
