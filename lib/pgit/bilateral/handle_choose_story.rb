require 'pgit'

module PGit
  module Bilateral
    class HandleChooseStory < ResponseHandler
      def initialize(options)
        @response = options.fetch(:response)
        @stories = options.fetch(:stories)
        @response_handlers = [PGit::Bilateral::HandleBack]
        name_parser = PGit::StoryBranch::NameParser.new(chosen_story)
        story_branch = PGit::StoryBranch.new(name_parser)

        story_branch.start
      end

      private

      def chosen_story
        @stories[@response.to_i]
      end

      def options(new_response)
        { response: new_response, stories: @stories, parent_question: @parent_question }
      end

      def response_can_be_handled?
        false
      end
    end
  end
end
