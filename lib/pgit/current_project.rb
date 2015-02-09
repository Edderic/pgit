require 'pgit'
require 'forwardable'

module PGit
  class CurrentProject
    extend Forwardable

    PGit::Project.instance_methods(false).each do |m|
      def_delegator :@current, m
    end

    def initialize(configuration)
      @current = configuration.projects.find do |p|
        File.expand_path(p.path) == Dir.pwd
      end

      raise PGit::Error::User, "Current Project does not exist. See `pgit proj add -h`" unless @current
    end
  end
end
