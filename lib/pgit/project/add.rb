require 'pgit'

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

        raise PGit::Error::User, adder.project.errors.full_messages.first unless adder.project.valid?
        adder.save!

        puts "Successfully added the project!"
      end
    end
  end
end
