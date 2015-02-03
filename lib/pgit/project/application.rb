
module PGit
  class Project
    class Application
      attr_reader :path, :api_token, :id
      def initialize(global_opts, opts, args)
        @path = opts.fetch(:path) { Dir.pwd }
        @api_token = opts.fetch(:api_token) { :no_api_token_provided }
        @id = opts.fetch(:id) { :no_id_provided }
      end

      def has_project_path?
      end
    end
  end
end
