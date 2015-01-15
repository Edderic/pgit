module PGit
  module Project
    class Add
      attr_reader :path

      def initialize(global_opts, opts, args)
        @path = opts[:path] || Dir.pwd
      end
    end
  end
end
