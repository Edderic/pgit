require 'pgit'

module PGit
  class Project
    class ReuseApiTokenAdder
      attr_reader :projects, :project
      def initialize(project_to_add_to, projects_in_config)
        @project = project_to_add_to
        @projects = projects_in_config
      end

      def execute!
        return false if @projects.empty?

        reuse_question.ask_and_wait_for_valid_response do |reuse_response|
          if reuse_response.yes?
            ask_which_one_and_wait_for_response
          end
        end
      end

      private

      def ask_which_one_and_wait_for_response
        resp = 'invalid'
        while resp == 'invalid' do
          print_options
          resp = response

          if resp.index?
            index = resp.to_i
            project.api_token = projects[index - 1].api_token
          elsif resp.cancel?
          else
            resp = 'invalid'
          end
        end
      end

      def print_options
        puts "Which one? [#{indices}c]"
        projects.each_with_index do |p, i|
          puts "  #{i+1}.  #{p.path}: #{p.api_token}"
        end
      end

      def response
        STDIN.gets.chomp
      end

      def indices
        str = ''
        projects.length.times { |i| str += "#{i+1}/" }
        str
      end

      def reuse_question
        Interactive::Question.new do |q|
          q.question = "Do you want to reuse an api token?"
          q.options = [:yes, :no]
        end
      end
    end
  end
end
