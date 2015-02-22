require 'pgit'

module PGit
  class Project
    class Add
      extend Forwardable

      attr_reader :adder
      def initialize(app)
        @app = app
        raise PGit::Error::User, 'Project path already exists. See `pgit proj update --help.`' if app.exists?

        @adder = PGit::Project::InteractiveAdder.new(app.project)
      end

      def execute!
        adder.execute!
        adder.save!

        puts "Successfully added the project!"
      end
    end
  end
end
