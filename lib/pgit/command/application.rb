module PGit
  class Command
    class Application
      attr_reader :commands, :global_opts, :opts, :args, :current_project
      def initialize(global_opts, opts, args)
        config = PGit::Configuration.new
        @current_project = PGit::CurrentProject.new(config.to_yaml)
        @global_opts = global_opts
        @args = args
        @opts = opts
        setup_commands
      end

      def command
        commands.find{|c| c.name == search }
      end

      private

      def setup_commands
        @commands = []
        current_project.commands.each do |name, steps|
          @commands << PGit::Command.new(name, steps)
        end
      end
    end
  end
end
