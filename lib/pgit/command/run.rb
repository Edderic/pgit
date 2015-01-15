require 'forwardable'

module PGit
  class Command
    class Run
      extend Forwardable
      def_delegators :@app, :commands, :args, :global_opts, :opts

      def initialize(app)
        @app = app
      end

      def execute!
        raise PGit::Command::NotFoundError.new(search) unless command

        command.execute
      end

      private

      def search
        raise PGit::UserError, "Run expects a command_name argument." if args.empty?
        args.first
      end

      def command
        commands.find {|c| c.name == args.first}
      end
    end
  end
end
