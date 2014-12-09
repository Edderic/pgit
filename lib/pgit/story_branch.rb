#
#   Used for creating a git branch in relation to a pivotal tracker story.
#
# - story_id: the id of the (pivotal tracker) story that you'll be
#   working on
#
# - config_yaml: the yaml with the projects. Each project has an api_token,
#   id, and path.

module PGit
  class StoryBranch
    attr_reader :id

    def initialize(story = nil, name_parser)
      if story
        @story = story
        @name_parser = name_parser
        @id = story.id
      else
        initialize_with_current_branch
      end
    end

    # a StoryBranch should not be started if the current branch name is the same?
    # Should not be able to checkout to a branch without a story_id...
    def start
      `git checkout -b #{branch_name}`
    end

    def name
      # story_json = JSON.parse(@story.get!)
      # name = story_json["name"]
      # story_id = story_json["id"]
      # name_parser = NameParser.new(name, story_id)
      @name_parser.parse
    end

    private

    # def validate_existence_id
      # raise "Error: #{@name} does not have a story id at the end" unless @id
    # end
#
    # def initialize_with_current_branch
      # @name = PGit::CurrentBranch.name
      # @id = @name.scan(/\d+$/).first
      # validate_existence_id
    # end
  end
end
