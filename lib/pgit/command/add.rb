require 'forwardable'
require 'pry-byebug'

module PGit
  class Command
    class Add
      extend Forwardable
      def_delegators :@app, :commands, :command, :args, :global_opts, :opts, :current_project
      def_delegators :command, :name

      def initialize(app)
        @app = app
      end

      def execute!
        check_command_exists_for_add

        command.save!
        display_success_msg(:added, :to)
      end

      private

      def exists?
        commands.find { |c| c.name == name }
      end

      def display_success_msg(event, preposition)
        puts "Successfully #{event} command '#{name}' #{preposition} the current project!"
      end

      def check_command_exists_for_add
        raise PGit::Error::User.new "Command '#{name}' already exists in the current project. If you want to update the command, see `pgit command update --help`" if exists?
      end
    end
  end
end
