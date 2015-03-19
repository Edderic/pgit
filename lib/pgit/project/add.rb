require 'pgit'

#TODO: Find a way to make execute! just be a call on children tasks
module PGit
  class Project
    class Add
      extend Forwardable

      attr_reader :adder
      def initialize(app)
        @app = app
        raise PGit::Error::User, 'Project path already exists. See `pgit proj update --help.`' if app.exists?

        @reuse_adder = PGit::Project::ReuseApiTokenAdder.new(app.project, app.projects)
      end

      def execute!
        @reuse_adder.execute!
        @adder = PGit::Project::InteractiveAdder.new(@reuse_adder.project)

        adder.execute!
        adder.save!

        puts "Successfully added the project!"
      end
    end
  end
end
