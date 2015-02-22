require 'pgit'

module PGit
  class Project
    class InteractiveAdder
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def execute!
        ungiven_attrs.each do |attr|
          puts "What's the project #{attr}?"
          project.send("#{attr}=", STDIN.gets.chomp)
        end
      end

      private

      def ungiven_attrs
        project.given_attrs.reject {|attr| project.send("given_#{attr}?")}
      end
    end
  end
end
