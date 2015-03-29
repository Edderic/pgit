require 'pgit'

module PGit
  module Bilateral
    class HandleChooseStory
      def initialize(response, stories)
        @response = response
        @stories = stories
      end

      def execute!
        question.ask do |r|
        end
      end

      private

      def chosen_story
        @stories[@response.to_i]
      end

      def string_options
        ["start it", "start it and branch out"]
      end

      def question
        Interactive::Question.new do |q|
          q.question = "What would you like to do with #{Rainbow(chosen_story.name).bright}?"
          q.options = [string_options, :back]
        end
      end
    end
  end
end
