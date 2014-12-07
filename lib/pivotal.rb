require 'yaml'
require 'json'
require 'optparse'
require_relative 'pgit_story'
require_relative 'pgit_current_project'
require_relative 'pgit_configuration'
require_relative 'pgit_story_branch'
require_relative 'pgit_name_parser'

# TODO:
# cf, config PATH
#   - sets the config path
#   - shows where the config file is if no argumets
#
#
# sbr, story_branch
#   -j, --join STORY_ID
#     * will check the remotes
#       * join if there's only one
#       * ask which one to join if n > 1
#       * if empty, ask if you mean 'start'
#   -s, --start STORY_ID
#     makes the parsed branch name and checkouts to it
#
#   -f, --finish
#     Finish
#       - fetch staging branch
#       - rebase on top of staging
#       - merge to local staging
#       - remove old branch locally
#       - remove old branch remotely
#       - push staging to remote
#       - push to heroku staging
#   -e, --edit STORY_ATTRIBUTE ARGS
#     * edits the story_attribute and sends a POST request
# cm, commit
#   * delegates to `git commit` but adds story-id
#
#
# Epic flag
# Start a story
# Display ACs
#   - done
#   - not done
#
# move to existing branch (story_id)
# Move to Next story (Assigned)
# Move to Next story (Unassigned)

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
