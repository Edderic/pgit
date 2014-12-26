module PGit
  class Command
    class EmptyError < PGit::Error
      def initialize
        @message = "No commands are listed for this project. Run `pgit command --add --name='command_name' --steps='step 1, step2'` to add a command for this project. You can also edit ~/.pgit.rc.yml directly"
        super @message
      end
    end
  end
end
