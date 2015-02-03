require 'forwardable'

module PGit
  module Project
    class Add
      extend Forwardable
      def_delegators :@app, :api_token, :path

      def initialize(app)
        @app = app
      end
    end
  end
end
