require 'yaml'
require 'json'
require 'optparse'
require_relative 'pgit/story'
require_relative 'pgit/current_project'
require_relative 'pgit/configuration'
require_relative 'pgit/story_branch'
require_relative 'pgit/name_parser'

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
