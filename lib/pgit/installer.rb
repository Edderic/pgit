module PGit
  class Installer
    def initialize(glob_opts, opts, args)
      file_path = "~/.pgit.rc.yml"
      @expanded_path = File.expand_path(file_path)

      if File.exists? @expanded_path
        raise "Error: #{file_path} already exists"
      else
        ask_continue
      end
    end

    def ask_continue
      puts  "*** Installing example pgit configuration file under ~/.pgit.rc.yml. Continue? [Y/n]"
      if STDIN.gets.chomp.match(/y/i)
        puts "Saving example pgit config in ~/.pgit.rc.yml..."
        write_example_pgit_rc_file
      else
        puts "Aborting installation..."
      end
    end

    def write_example_pgit_rc_file
      File.open(@expanded_path, 'w') do |f|
        f.puts "---"
        f.puts "projects:"
        f.puts "  - path: ~/some/path/to/a/pivotal-git/project"
        f.puts "    id: 12345"
        f.puts "    api_token: somepivotalatoken124"

        f.puts "  - path: ~/some/other/pivotal-git/project"
        f.puts "    id: 23429070"
        f.puts "    api_token: somepivotalatoken124"
        f.close
      end

      puts "Saved! Please edit ~/.pgit.rc.yml and add the proper Pivotal Tracker API tokens, id, and file paths for each project"
    end
  end
end
