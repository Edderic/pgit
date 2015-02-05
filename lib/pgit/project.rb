require 'pgit'

module PGit
  class Project
    attr_reader :path, :api_token, :id, :commands
    def initialize(configuration=:no_config_provided,
                   project_hash=:no_proj_hash_provided,
                   &block)
      proj = Hash.new
      block_given? ? yield(proj) : proj = project_hash

      @configuration = configuration
      @path = proj.fetch('path') { Dir.pwd }
      @api_token = proj.fetch('api_token')
      @id = proj.fetch('id')
      @commands = build_commands(proj.fetch('commands') { Array.new })
    end

    [:id, :path, :api_token].each do |method_name|
      define_method "has_#{method_name}?" do |val|
        instance_variable_get("@#{method_name}") == val
      end
    end

    def to_hash
      {
        "path" => path,
        "api_token" => api_token,
        "id" => id,
        "commands" => @commands.map {|cmd| puts cmd.to_hash; cmd.to_hash}
      }
    end

    private

    def build_commands(cmds)
      cmds.map do |cmd|
        cmd.map { |k,v| PGit::Command.new(k, v, self) }.first
      end
    end
  end
end
