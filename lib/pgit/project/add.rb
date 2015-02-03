require 'forwardable'

module PGit
  class Project
    class Add
      extend Forwardable
      def_delegators :@app, :api_token, :path

      def initialize(app)
        @app = app

        raise PGit::Error::User, 'Project path already exists' if app.has_project_path?
      end
    end
  end
end
