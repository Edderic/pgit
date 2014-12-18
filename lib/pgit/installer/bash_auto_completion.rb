module PGit
  module Installer
    class BashAutoCompletion
      def self.script
        autocompletion = <<-AUTOCOMPLETION
          function get_pgit_commands
          {
            if [ -z $2 ]; then
              COMPREPLY=(`pgit help -c`)
            else
              COMPREPLY=(`pgit help -c $2`)
            fi
          }
          complete -F get_pgit_commands pgit
        AUTOCOMPLETION

        PGit::Heredoc.remove_front_spaces(autocompletion)
      end


      def initialize(global_opts, opts, args)
      end

      def write_completer_file
        expanded_path = File.expand_path("~/.pgit_auto_completion")
        f = File.open(expanded_path, 'w')
        f.puts PGit::Installer::BashAutoCompletion.script
        f.close

        puts "Wrote autocompletion script under ~/.pgit_auto_completion"
      end

      def source_completer_from_bashrc
        if already_sourced?
          puts "Already sourcing ~/.pgit_auto_completion in ~/.bashrc"
        else
          bashrc_expanded_path = File.expand_path("~/.bashrc")
          b = File.open(bashrc_expanded_path, 'a')
          b.puts "source ~/.pgit_auto_completion"
          b.close
        end
      end

      private

      def already_sourced?
        expanded_bashrc = File.expand_path("~/.bashrc")
        lines = File.readlines(expanded_bashrc)
        already_sourced = lines.any? {|line| line.match(/source ~\/.pgit_auto_completion/) }
      end
    end
  end
end

