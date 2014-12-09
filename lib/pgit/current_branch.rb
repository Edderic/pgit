module PGit
  class CurrentBranch
    def initialize
      @branches = `git branch`

      raise @branches unless current.any?
    end

    def name
      current.first.gsub(/\*\s*/, '')
    end

    def story_id
      name.scan(/\d+$/).first
    end

    private

    def current
      @branches.scan(/\*.+/)
    end
  end
end
