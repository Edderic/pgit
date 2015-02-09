require 'forwardable'

module PGit
  class Command
    class Remove
      extend Forwardable
      def_delegators :@app, :commands, :command, :args, :global_opts, :opts, :current_project
      def_delegators :command, :name

      def initialize(app)
        @app = app
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
        raise PGit::Error::User.new "Cannot remove a command that does not exist in the current project. See `pgit cmd add --help` if you want to add a new command" unless exists?
      end
    end
  end
end
