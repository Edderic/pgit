module PGit
  class CurrentProject
    class Command
      attr_reader :current_project, :command, :commands

      def initialize(name, steps)
        @command = PGit::Command.new(name, steps)
        config_yaml = PGit::Configuration.new.yaml
        @current_project = PGit::CurrentProject.new(config_yaml)
        @commands = []
        @current_project.commands.each do |name, steps|
          @commands << PGit::Command.new(name, steps)
        end
      end

      def exists?
        commands.find { |c| c.name == name }
      end

      def name
        command.name
      end

      def add
        raise PGit::Command::UserError.new "Command '#{name}' already exists in the current project. If you want to update the command, see `pgit command update --help`" if exists?

        command.save
        puts "Successfully added '#{name}' to the current projects' commands!"
      end

      def update
        raise PGit::Command::UserError.new "Cannot update a command that does not exist in the current project. See `pgit command add --help` if you want to add a new command" if !exists?

        command.save
        puts "Successfully updated command '#{name}' of the current project!"
      end
    end
  end
end
