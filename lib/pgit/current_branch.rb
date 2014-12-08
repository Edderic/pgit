module PGit
  class CurrentBranch
    def self.name
      branches = `git branch`
      branches.scan(/\*.+/).first.gsub(/\*\s*/, '')
    end
  end
end
