require 'forwardable'

module PGit
  class Command
    class Remove
      extend Forwardable
      def_delegators :@app, :commands, :args, :global_opts, :opts, :current_project
      def_delegators :@command, :name

      attr_reader :command
      def initialize(app)
        @app = app
        @command = PGit::Command.new(opts.fetch(:name),
                                     opts.fetch(:steps){ ['fake_steps'] },
                                     current_project)
      end

      def execute!
        check_command_exists_for_remove

        command.remove!
        display_success_msg
      end

      private

      def exists?
        commands.find { |c| c.name == name }
      end

      def display_success_msg
        puts "Successfully removed command '#{name}' from the current project!"
      end

      def check_command_exists_for_remove
        raise PGit::Error::User.new "Cannot remove a command that does not exist in the current project. See `pgit command add --help` if you want to add a new command" unless exists?
      end
    end
  end
end
