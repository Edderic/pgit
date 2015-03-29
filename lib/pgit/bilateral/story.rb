require 'pgit'

module PGit
  module Bilateral
    class Story
      include Interactive
      def initialize
        @iterations_obj = PGit::Pivotal::Iterations.new(scope: :current_backlog)
        @iterations = @iterations_obj.get!
      end

      def execute!
        which_question.ask do |which_response|
        end
      end

      def stories
        @iterations.inject([]) do |accum, iteration|
          accum | iteration.stories
        end
      end

      def which_question
        Question.new do |which_question|
          which_question.question = "Which story are you interested in?"
          which_question.options = [stories, :back]
          which_question.columns = [:index, :story_type, :estimate, :name, :current_state]
        end
      end
    end
  end
end
