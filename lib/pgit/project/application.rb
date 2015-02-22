require 'forwardable'

module PGit
  class Project
    class Application
      extend Forwardable
      def_delegators :@project, :exists?, :save!
      def_delegators :@config, :projects
      attr_reader :project

      def initialize(global_opts, opts, args)
        @config = PGit::Configuration.new
        @project = PGit::Project.new(@config) do |p|
          p.path = opts["path"]
          p.api_token = opts["api_token"]
          p.id = opts["id"]
        end
      end
    end
  end
end
