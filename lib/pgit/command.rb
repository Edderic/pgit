module PGit
  class Command
    attr_reader :name, :steps

    def initialize(name, steps)
      @name = name
      @steps = steps
    end

    def execute
      branch_name = PGit::CurrentBranch.new.name

      @steps.each do |step|
        step.gsub!(/STORY_BRANCH/, branch_name)

        begin
          puts "About to execute '#{formatted_step(step)}'. Proceed? #{exec_options}"
          response = STDIN.gets.chomp

          if response.letter?('s')
            puts formatted_action('Skipping...')
          elsif response.letter?('q')
            puts formatted_action("Quitting...")
            break
          elsif response.letter?('y')
            puts "#{formatted_action('Executing')} '#{formatted_step(step)}'..."
            puts `#{step}`
          else
            show_options
            raise PGit::InvalidOptionError
          end
        rescue PGit::InvalidOptionError
          retry
        end
      end
    end

    def to_h
      to_hash
    end

    def to_hash
      { name => steps }
    end

    def to_s
      steps.inject("#{name}:\n") {|accum, step| accum + "  #{step}\n" }
    end

    def save
      config = PGit::Configuration.new
      current_project = PGit::CurrentProject.new(config.yaml)

      current_project.commands.merge!(to_hash)
      current_project.save
    end

    private

    def formatted_action(action)
      Rainbow(action).color(:yellow)
    end

    def formatted_step(step)
      Rainbow(step).bright
    end
    def exec_options
      Rainbow("[Y/s/q]").color("#FF6FEA")
    end

    def show_options
      message = <<-LEGAL_OPTIONS
        y  - yes
        s  - skip
        q  - quit
      LEGAL_OPTIONS

      puts Rainbow(PGit::Heredoc.remove_front_spaces(message)).red
    end
  end
end
