require 'forwardable'
module PGit
  class Project
    class InteractiveAdder
      extend Forwardable
      def_delegators :@project, :api_token, :id, :save!
      attr_reader :project

      def initialize(project)
        @project = project

        if api_token == :no_api_token_provided

          puts "What's the Pivotal Tracker API token? (See 'Profile' section at http://pivotaltracker.com)"
          @project.api_token = STDIN.gets.chomp
        end

        if id == :no_id_provided

          puts "What's the id of this project (i.e. https://www.pivotaltracker.com/n/projects/XXXX wher XXXX is the id)?"
          @project.id = STDIN.gets.chomp
        end
      end
    end
  end
end
