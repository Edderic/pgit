require 'forwardable'
module PGit
  class Command
    class Application
      extend Forwardable
      def_delegators :@current_project, :commands

      attr_reader :global_opts, :opts, :args, :current_project, :command
      def initialize(global_opts, opts, args)
        configuration = PGit::Configuration.new
        @current_project = PGit::CurrentProject.new(configuration)
        @global_opts = global_opts
        @command = PGit::Command.new(opts.fetch("name") { :no_name_provided },
                                     opts.fetch("steps") { [:no_steps_provided] },
                                     @current_project)
        @args = args
        @opts = opts
      end
    end
  end
end
