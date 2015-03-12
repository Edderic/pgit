require 'pgit'

module PGit
  class Project < PGit::Pivotal::Request
    include ActiveModel::Validations
    include PGit::Helpers::QueryMethods
    extend PGit::Helpers::QueryMethods

    validates_with PGit::Validators::ProjectValidator

    attr_writer :api_token, :id, :path
    attr_reader :path, :api_token, :id, :configuration
    attr_query :id, :path, :api_token

    def initialize(configuration=:no_config_given,
                   proj={},
                   &block)
      yield self if block_given?
      @query_hash = proj
      @configuration = configuration
      @cmds = proj.fetch('commands') { Array.new }
      set_default_queries
    end

    def commands=(some_commands)
      @cmds = some_commands
    end

    def commands
      build_commands(@cmds)
    end

    def to_hash
      {
        "path" => path,
        "api_token" => api_token,
        "id" => id,
        "commands" => commands.map {|cmd| cmd.to_hash}
      }
    end

    def save!
      ensure_given_queries

      remove_old_copy { configuration.projects = configuration.projects << self }
    end

    def remove!
      remove_old_copy
    end

    def exists?
      configuration.projects.find {|p| p.path == path}
    end

    private

    def remove_old_copy
      configuration.projects = configuration.projects.reject {|p| p.path == path}
      yield if block_given?
      configuration.save!
    end

    def build_commands(cmds)
      cmds.map do |cmd|
        if cmd.respond_to?(:name) && cmd.respond_to?(:steps)
          cmd
        else
          cmd.map { |k,v| PGit::Command.new(k, v, self) }.first
        end
      end
    end
  end
end
