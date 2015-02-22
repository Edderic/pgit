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
        project.defaulted_attrs.each do |attr|
          puts "What's the project #{attr}?"
          project.send("#{attr}=", STDIN.gets.chomp)
        end
      end
    end
  end
end
