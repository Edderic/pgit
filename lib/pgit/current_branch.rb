module PGit
  class CurrentBranch
    def self.name
      branches = `git branch`
      match = branches.scan(/\*.+/)
      if match.any?
        match.first.gsub(/\*\s*/, '')
      else
        raise branches
      end
    end
  end
end
