module PGit
  class Command
    attr_reader :name, :steps

    def initialize(name, steps)
      @name = name
      @steps = steps
    end

    def execute
      @steps.each do |step|
        step.gsub!(/STORY_BRANCH/, PGit::CurrentBranch.new.name)
        puts `#{step}`
      end
    end
  end
end
