
module PGit
  module Project
    class Application
      attr_reader :path, :api_token
      def initialize(global_opts, opts, args)
        @path = opts.fetch(:path) { Dir.pwd }
        @api_token = opts.fetch(:api_token) { :no_api_token_provided }
      end
    end
  end
end
