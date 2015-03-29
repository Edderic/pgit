require 'pgit'

module PGit
  module Bilateral
    class HandleChooseStory
      def initialize(options)
        @response = options.fetch(:response)
        @stories = options.fetch(:stories)
        @parent_question = options.fetch(:parent_question)
      end

      def execute!
        if response_can_be_handled?
          question.ask do |new_response|
            PGit::Bilateral::HandleBack.new(options(new_response)).execute!
          end
        end
      end

      private

      def chosen_story
        @stories[@response.to_i]
      end

      def string_options
        ["start it", "start it and branch out"]
      end

      def options(new_response)
        { response: new_response, stories: @stories, parent_question: @parent_question }
      end

      def question
        Interactive::Question.new do |q|
          q.question = "What would you like to do with #{Rainbow(chosen_story.name).bright}?"
          q.options = [string_options, :back]
        end
      end

      def response_can_be_handled?
        @response.whole_number?
      end
    end
  end
end
