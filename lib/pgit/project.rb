require 'pgit'
require 'byebug'

module PGit
  class Project
    attr_writer :api_token, :id, :path
    attr_reader :path, :api_token, :id, :configuration

    def initialize(configuration=:no_config_provided,
                   proj={},
                   &block)
      yield self if block_given?
      @proj_hash = proj
      @configuration = configuration
      set_attr('path') { Dir.pwd }
      set_attr('api_token') { not_provided(:api_token) }
      set_attr('id') { not_provided(:id) }
      @cmds = proj.fetch('commands') { Array.new }
    end

    [:id, :path, :api_token].each do |method_name|
      define_method "has_#{method_name}?" do |val|
        instance_variable_get("@#{method_name}") == val
      end
    end

    [:api_token, :id].each do |item|
      define_method "given_#{item}?" do
        instance_variable_get("@#{item}") != not_provided(item)
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
      ensure_provided(:api_token)
      ensure_provided(:id)

      remove_old_copy { configuration.projects = configuration.projects << self }
    end

    def remove!
      remove_old_copy
    end

    def exists?
      configuration.projects.find {|p| p.path == path}
    end

    private
    def set_attr(attribute)
      unless instance_variable_get("@#{attribute}")
        instance_variable_set("@#{attribute}", @proj_hash[attribute] || yield)
      end
    end

    def ensure_provided(attribute)
      attr = send(attribute)
      raise PGit::Error::User, attr if attr == not_provided(attribute)
    end

    def not_provided(attribute)
      "no_#{attribute}_provided".to_sym
    end

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
