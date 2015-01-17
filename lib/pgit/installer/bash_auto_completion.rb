module PGit
  module Installer
    class BashAutoCompletion
      FILENAME = "~/.pgit_auto_completion"

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

        PGit::Helpers::Heredoc.remove_front_spaces(autocompletion)
      end

      def initialize(global_opts, opts, args)
      end

      def write_completer_file
        expanded_path = File.expand_path(FILENAME)
        f = File.open(expanded_path, 'w')
        f.puts PGit::Installer::BashAutoCompletion.script
        f.close

        puts "Wrote autocompletion script under #{FILENAME}"
      end

      def source_completer_from_bashrc
        if already_sourced?
          puts "Already sourcing #{FILENAME} in ~/.bashrc"
        else
          bashrc_expanded_path = File.expand_path("~/.bashrc")
          b = File.open(bashrc_expanded_path, 'a')
          b.puts "source #{FILENAME}"
          b.close

          puts "~/.bashrc will now source #{FILENAME}"
        end
      end

      private

      def already_sourced?
        expanded_bashrc = File.expand_path("~/.bashrc")
        lines = File.readlines(expanded_bashrc)
        already_sourced = lines.any? {|line| line.match(/source #{FILENAME}/) }
      end
    end
  end
end

