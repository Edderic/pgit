require 'pgit'

module PGit
  class Project
    attr_writer :api_token, :id
    attr_reader :path, :api_token, :id, :configuration
    def initialize(configuration=:no_config_provided,
                   proj={},
                   &block)
      yield proj if block_given?

      @configuration = configuration
      @path = proj['path'] || Dir.pwd
      @api_token = proj['api_token'] || :no_api_token_provided
      @id = proj['id'] || :no_id_provided
      @cmds = proj.fetch('commands') { Array.new }
    end

    [:id, :path, :api_token].each do |method_name|
      define_method "has_#{method_name}?" do |val|
        instance_variable_get("@#{method_name}") == val
      end
    end

    [:api_token, :id].each do |item|
      define_method "given_#{item}?" do
        instance_variable_get("@#{item}") != "no_#{item}_provided".to_sym
      end
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
      raise PGit::Error::User, api_token if api_token == :no_api_token_provided
      raise PGit::Error::User, id if id == :no_id_provided

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
