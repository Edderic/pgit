require 'forwardable'

module PGit
  class Project
    class Add
      extend Forwardable
      def_delegators :@app, :api_token, :path

      def initialize(app)
        @app = app

        raise PGit::Error::User, 'Project path already exists. See `pgit proj update --help.`' if app.exists?
      end

      def execute!
        @app.save!
        puts "Successfully added the project!"
      end
    end
  end
end
