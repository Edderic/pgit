module PGit
  class CurrentProject
    class Command
      attr_reader :current_project, :command, :commands

      def initialize(name, steps=[])
        @command = PGit::Command.new(name, steps)
        config_yaml = PGit::Configuration.new.yaml
        @current_project = PGit::CurrentProject.new(config_yaml)

        initialize_commands
      end

      def exists?
        commands.find { |c| c.name == name }
      end

      def name
        command.name
      end

      def remove
        check_command_exists_for_remove

        @current_project.commands.reject! { |k,v| k == name }
        @current_project.save
        display_success_msg(:removed, :from)
      end

      def add
        check_command_exists_for_add

        command.save
        display_success_msg(:added, :to)
      end

      def update
        check_command_exists_for_update

        command.save
        display_success_msg(:updated, :of)
      end

      private

      def initialize_commands
        @commands = []
        @current_project.commands.each do |name, steps|
          @commands << PGit::Command.new(name, steps)
        end
      end

      def display_success_msg(event, preposition)
        puts "Successfully #{event} command '#{name}' #{preposition} the current project!"
      end

      def check_command_exists_for_update
        raise PGit::Command::UserError.new "Cannot update a command that does not exist in the current project. See `pgit command add --help` if you want to add a new command" unless exists?
      end

      def check_command_exists_for_add
        raise PGit::Command::UserError.new "Command '#{name}' already exists in the current project. If you want to update the command, see `pgit command update --help`" if exists?
      end

      def check_command_exists_for_remove
        raise PGit::Command::UserError.new "Command '#{name}' does not exist in the current project" unless exists?
      end
    end
  end
end
