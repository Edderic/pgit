module PGit
  module Installer
    class Configuration
      FILEPATH = "~/.pgit.rc.yml"
      def initialize(glob_opts, opts, args)
        @expanded_path = File.expand_path(FILEPATH)

        if File.exists? @expanded_path
          raise "#{FILEPATH} already exists"
        else
          ask_continue
        end
      end

      def ask_continue
        puts  "*** Installing example pgit configuration file under #{FILEPATH}. Continue? [Y/n]"
        if STDIN.gets.chomp.match(/y/i)
          puts "Saving example pgit config in #{FILEPATH}..."
          write_example_pgit_rc_file
        else
          puts "Aborting installation..."
        end
      end

      def write_example_pgit_rc_file
        File.open(@expanded_path, 'w') do |f|
          YAML.dump(PGit::Configuration.default_options, f)
        end

        puts "Saved! Please edit #{FILEPATH} and add the proper Pivotal Tracker API tokens, id, and file paths for each project"
      end
    end
  end
end
