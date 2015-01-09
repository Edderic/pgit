module PGit
  class CurrentProject
    class Command
      class Show
        attr_reader :commands, :opts, :current_project
        def initialize(global_opts, opts, args)
          config = PGit::Configuration.new
          @current_project = PGit::CurrentProject.new(config.to_yaml)
          @opts = opts
          setup_commands
          show
        end

        def show
          raise PGit::Command::EmptyError if commands.empty?
          puts "Listing custom commands of the current project..."
          puts
          commands.each do |c|
            puts c.to_s
          end
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
end
