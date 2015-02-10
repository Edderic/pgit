require 'forwardable'
module PGit
  class Project
    class InteractiveAdder
      extend Forwardable
      def_delegators :@project, :api_token, :id, :save!
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def gather_missing_data
        gather_api_token
        gather_id
      end

      private

      def gather(var_name, proper_value, question)
        if @project.send(var_name) == proper_value
          puts question
          @project.send("#{var_name}=", STDIN.gets.chomp)
        end
      end

      def gather_api_token
        question = "What's the Pivotal Tracker API token (See http://pivotaltracker.com/profile)?"
        gather('api_token', :no_api_token_provided, question)
      end

      def gather_id
        question =  "What's the id of this project (i.e. https://www.pivotaltracker.com/n/projects/XXXX where XXXX is the id)?"
        gather('id', :no_id_provided, question)
      end
    end
  end
end
