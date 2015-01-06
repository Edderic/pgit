module PGit
  class Command
    class Application
      attr_reader :commands, :opts, :current_project
      def initialize(global_opts, opts, args)
        config = PGit::Configuration.new
        @current_project = PGit::CurrentProject.new(config.to_yaml)
        @opts = opts
        setup_commands

        if opts[:list]
          list
        elsif opts[:execute]
          execute
        else
          puts `pgit command --help`
        end
      end

      def list
        raise PGit::Command::EmptyError if commands.empty?
        puts "Listing custom commands of the current project..."
        puts
        commands.each do |c|
          puts c.to_s
        end
      end

      def execute
        command = find_command
        raise PGit::Command::NotFoundError.new(opts[:execute]) unless command

        command.execute
      end

      private

      def find_command
        commands.find{|c| c.name == opts[:execute] }
      end

      def setup_commands
        @commands = []
        current_project.commands.each do |name, steps|
          @commands << PGit::Command.new(name, steps)
        end
      end
    end
  end
end
