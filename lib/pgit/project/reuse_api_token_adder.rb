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

        puts "Do you want to reuse an api token? [Y/n]"

        if response.letter?('y')
          print_options

          r = response

          if r.index?
            index = r.to_i
            project.api_token = projects[index - 1].api_token
          elsif r.letter?('c')

          else
            print_options
          end
        end
      end

      private

      def print_options
        puts "Which one? [#{projects.length}/c]"
        projects.each_with_index do |p, i|
          puts "  #{i+1}.  #{p.path}: #{p.api_token}"
        end
      end

      def response
        STDIN.gets.chomp
      end
    end
  end
end
