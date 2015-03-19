require 'interactive'
module PGit
  class Project
    class Remove
      include Interactive

      attr_reader :project, :projects
      def initialize(app)
        @project = app.project
        @projects = app.projects

        raise PGit::Error::User, "#{@project.path} is not in the configuration file." unless @project.exists?
      end

      def execute!
        confirm.ask_and_wait_for_valid_response do |confirm_response|
          if confirm_response.yes?
            puts "Removing #{path} from the configuration file..."
            project.remove!
            puts "Removed."
          elsif confirm_response.no?
            puts "Cancelling..."
          end
        end
      end

      private

      def confirm
        Question.new do |c|
          c.question = "Are you sure you want to remove #{path} from the configuration file?"
          c.options = [:yes, :no]
        end
      end

      def path
        @project.path
      end
    end
  end
end
