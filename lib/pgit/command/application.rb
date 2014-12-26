module PGit
  class Command
    class Application
      attr_reader :commands
      def initialize(global_opts, opts, args)
        config = PGit::Configuration.new
        current_project = PGit::CurrentProject.new(config.to_yaml)
        @commands = current_project.commands

        if opts[:list]
          list
        end
      end

      def list
        puts "Listing custom commands of the current project..."
        puts
        commands.each do |c|
          c.each do |name, steps|
            command = PGit::Command.new(name, steps)
            puts command.to_s
          end
        end
      end
    end
  end
end
