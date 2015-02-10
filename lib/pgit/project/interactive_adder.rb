require 'forwardable'
require 'pgit'

module PGit
  class Project
    class InteractiveAdder
      extend Forwardable
      def_delegators :@project, :api_token, :id, :save!, :configuration
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
          if configuration.projects.any?
            question1 = 'There is at least one project saved in the configuration file. Do you want to reuse a project id? [Y/n]'
            puts question1
            if STDIN.gets.chomp.letter?('y')
              projects = configuration.projects
              ids = projects.map_with_index {|proj, i| "#{i}. path: #{proj.path}, id: #{proj.id}"}
              ids.inject("Which one?") {|accum, item| accum + "#{item}\n"}
            else
            end
          else
            puts question
            @project.send("#{var_name}=", STDIN.gets.chomp)
          end
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
