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
        error_message = "Command '#{search}' does not exist. Run 'pgit command show' to see the available custom commands."
        raise PGit::Error::User, error_message unless command

        command.execute
      end

      private

      def search
        raise PGit::Error::User, "Run expects a command_name argument." if args.empty?
        args.first
      end

      def command
        commands.find {|c| c.name == args.first}
      end
    end
  end
end
