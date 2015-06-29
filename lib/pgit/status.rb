class PGit::Status
  def initialize(global_options, options, args)
  end

  def execute!
    current_branch = PGit::CurrentBranch.new
    raise PGit::Error::User, 'The current branch is not associated with a story. Does not have a story id.' unless current_branch.story_id
    story = PGit::Pivotal::Story.new(current_branch.story_id)
    story_hash = story.get!
    table = Terminal::Table.new do |t|
      t.rows = story_hash.to_a
    end

    puts table
  end
end
