require 'forwardable'

module PGit
  class Command
    class Edit
      extend Forwardable
      def_delegators :@app, :commands, :args, :global_opts, :opts
      def_delegators :@command, :name

      attr_reader :command
      def initialize(app)
        @app = app
        @command = PGit::Command.new(opts.fetch(:name), opts.fetch(:steps))
      end

      def execute!
        check_command_exists_for_update

        command.save
        display_success_msg
      end

      private

      def exists?
        commands.find { |c| c.name == name }
      end

      def display_success_msg
        puts "Successfully edited command '#{name}' of the current project!"
      end

      def check_command_exists_for_update
        raise PGit::Error::User.new "Cannot edit a command that does not exist in the current project. See `pgit command add --help` if you want to add a new command" unless exists?
      end
    end
  end
end
