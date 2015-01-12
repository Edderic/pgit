require 'delegate'
require 'rainbow'
require 'forwardable'

module PGit
  class CurrentProject
    class Command
      class Show
        extend Forwardable
        def_delegators :@app, :commands, :args, :global_opts, :opts

        def initialize(app)
          @app = app
        end

        def execute!
          raise PGit::Command::EmptyError if commands.empty?

          if search.empty?
            show_all_of_current_project
          else
            show_one
          end
        end

        def search
          args.first || []
        end

        private

        def show_all_of_current_project
          puts "Listing custom commands of the current project..."
          puts
          commands.each { |c| puts c.to_s }
          puts
        end

        def command
          commands.find { |c| c.name == search }
        end

        def show_one
          raise PGit::Command::UserError, "Command '#{search}' not found for this project" unless command

          puts "Listing custom command '#{Rainbow(command.name).bright}' of the current project..."
          puts
          puts command.to_s
          puts
        end
      end
    end
  end
end
