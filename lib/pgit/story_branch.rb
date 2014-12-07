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
    def initialize(story_id, config_yaml)
      current_project = CurrentProject.new(config_yaml)
      project_id = current_project.id
      api_token = current_project.api_token

      @story = Story.new(story_id, project_id, api_token)
    end

    def start
      story_json = JSON.parse(@story.get!)
      name = story_json["name"]
      story_id = story_json["id"]
      name_parser = NameParser.new(name, story_id)
      branch_name = name_parser.parse

      `git checkout -b #{branch_name}`
    end
  end
end
