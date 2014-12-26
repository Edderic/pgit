module PGit
  class Command
    class Application
      attr_reader :commands, :opts, :current_project
      def initialize(global_opts, opts, args)
        config = PGit::Configuration.new
        @current_project = PGit::CurrentProject.new(config.to_yaml)
        @commands = []
        @opts = opts
        setup_commands

        if opts[:list]
          list
        elsif opts[:execute]
          execute
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
        current_project.commands.each do |c|
          c.each do |name, steps|
            @commands << PGit::Command.new(name, steps)
          end
        end
      end
    end
  end
end
