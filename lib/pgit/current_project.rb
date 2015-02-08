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
    end
  end
end
