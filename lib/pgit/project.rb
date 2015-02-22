require 'pgit'

module PGit
  class Project
    include PGit::Helpers::QueryMethods
    extend PGit::Helpers::QueryMethods

    attr_writer :api_token, :id, :path
    attr_reader :path, :api_token, :id, :configuration
    attr_has :id, :path, :api_token
    attr_given :id, :api_token

    def initialize(configuration=:no_config_provided,
                   proj={},
                   &block)
      yield self if block_given?
      @proj_hash = proj
      @configuration = configuration
      set_attr(:path) { not_provided(:path) }
      set_attr(:api_token) { not_provided(:api_token) }
      set_attr(:id) { not_provided(:id) }
      @cmds = proj.fetch('commands') { Array.new }
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
      ensure_provided(:api_token)
      ensure_provided(:id)
      ensure_provided(:path)

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
