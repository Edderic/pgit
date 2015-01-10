require 'pgit/command/application'

module PGit
  class CurrentProject
    class Command
      class Show < PGit::Command::Application
        def execute!
          raise PGit::Command::EmptyError if commands.empty?
          puts "Listing custom commands of the current project..."
          puts
          commands.each do |c|
            puts c.to_s
          end
        end
      end
    end
  end
end
