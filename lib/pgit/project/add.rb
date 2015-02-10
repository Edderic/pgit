require 'pgit'
require 'forwardable'

module PGit
  class Project
    class Add
      extend Forwardable
      def_delegators :@app, :project

      def initialize(app)
        @app = app
        raise PGit::Error::User, 'Project path already exists. See `pgit proj update --help.`' if app.exists?

        @adder = PGit::Project::InteractiveAdder.new(project)
      end

      def execute!
        @adder.save!
        puts "Successfully added the project!"
      end
    end
  end
end
