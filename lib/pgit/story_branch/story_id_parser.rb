class PGit::StoryBranch::StoryIdParser
  def initialize(branch_name)
    @branch_name = branch_name
  end

  def parse
    raise PGit::Error::User, "The current branch is not associated with a story. Does not have a story id." unless @branch_name.match(/\d+$/)

    @branch_name.match(/\d+$/)[0]
  end
end
