module PGit
  class Application
    def initialize(argv)
      # usage_message = "Usage: pgit\n"\
      # "  cob [pivotal-story-id]"
      # print usage_message
      unless argv.first
        raise 'POOP'
      end

      story_id = argv.first
      config_yaml = Pivotal::Configuration.new.to_yaml

      branch = Pivotal::Git::StoryBranch.new(story_id, config_yaml)
      branch.create_and_checkout
    end
  end
end
