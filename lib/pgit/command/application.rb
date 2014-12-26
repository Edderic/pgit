module PGit
  class Command
    class Application
      attr_reader :commands, :opts
      def initialize(global_opts, opts, args)
        config = PGit::Configuration.new
        current_project = PGit::CurrentProject.new(config.to_yaml)
        @opts = opts
        @commands = []
        current_project.commands.each do |c|
          c.each do |name, steps|
            @commands << PGit::Command.new(name, steps)
          end
        end

        if opts[:list]
          list
        elsif opts[:execute]
          execute
        end
      end

      def list
        puts "Listing custom commands of the current project..."
        puts
        @commands.each do |c|
          puts c.to_s
        end
      end

      def execute
        s = @commands.find{|c| c.name == opts[:execute] }
        s.execute
      end
    end
  end
end
