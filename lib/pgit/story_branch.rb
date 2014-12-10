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

    def initialize(name_parser)
      @name_parser = name_parser
    end

    def start
      `git checkout -b #{name}`
    end

    def name
      @name_parser.name
    end

    def id
      @name_parser.story_id
    end
  end
end
