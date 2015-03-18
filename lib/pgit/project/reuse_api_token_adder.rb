require 'pgit'

module PGit
  class Project
    class ReuseApiTokenAdder
      include Interactive

      attr_reader :projects, :project
      def initialize(project_to_add_to, projects_in_config)
        @project = project_to_add_to
        @projects = projects_in_config
      end

      def execute!
        return false if @projects.empty?

        reuse_question.ask_and_wait_for_valid_response do |reuse_response|
          if reuse_response.yes?
            which_to_reuse_question.ask_and_wait_for_valid_response do |which_response|
              if which_response.whole_number?
                project.api_token = projects[which_response.to_i].api_token
              end
            end
          end
        end
      end

      private

      def reuse_question
        Question.new do |q|
          q.question = "Do you want to reuse an api token?"
          q.options = [:yes, :no]
        end
      end

      def which_to_reuse_question
        Question.new do |q|
          q.question = "Which one?"
          q.options = [projects.map{|proj| "#{proj.path}: #{proj.api_token}"}, :cancel]
        end
      end
    end
  end
end
