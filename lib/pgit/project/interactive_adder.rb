require 'pgit'
require 'forwardable'

module PGit
  class Project
    class InteractiveAdder
      extend Forwardable

      def_delegators :@project, :save!
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def execute!
        if project.api_token == :no_api_token_given
          puts "What's the project api_token?"
          project.api_token = STDIN.gets.chomp
        end

        get_projects
      end

      def get_projects
        projects = PGit::Pivotal::Projects.new(api_token: project.api_token).get!
        question = Interactive::Question.new do |q|
          q.question = "Which project do you want to associate with the working directory?"
          q.options = [projects]
          q.columns = [:index, :name]
        end

        question.ask do |response|
          if response.whole_number?
            project.id = projects[response.to_i].id
          end
        end
      end
    end
  end
end
