require 'pgit/command/application'

module PGit
  class Command
    class Run < PGit::Command::Application
      def execute!
        raise PGit::Command::NotFoundError.new(search) unless command

        command.execute
      end

      private

      def search
        raise PGit::Command::UserError, "Run expects a command_name argument." if args.empty?
        args.first
      end
    end
  end
end
