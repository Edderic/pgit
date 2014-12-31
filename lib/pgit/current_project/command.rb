module PGit
  class CurrentProject
    class Command
      attr_reader :current_project, :command, :commands

      def initialize(command)
        @command = command
        config_yaml = PGit::Configuration.new.yaml
        @current_project = PGit::CurrentProject.new(config_yaml)
        @commands = []
        @current_project.commands.each do |name, steps|
          @commands << PGit::Command.new(name, steps)
        end
      end

      def exists?
        commands.find do |c|
          c.name == command.name
        end
      end

      def name
        command.name
      end

      def add
        if exists?
          warn "Command '#{name}' already exists in the current project. If you want to update the command, see `pgit command update --help`"
        end
      end
      #
      # def update
      # end
      #
      # def destroy
      # end
      #
      # def save
      # end
    end
  end
end
