require 'pgit'

module PGit
  module Bilateral
    class Story
      include Interactive
      attr_reader :question
      def initialize(options)
        raise PGit::Error::User, "Invalid options. See `pgit iteration -h` for valid options." unless options_has_valid_scope(options)

        @iterations_obj = PGit::Pivotal::Iterations.new(get_scope_hash(options))
        @iterations = @iterations_obj.get!
        @question = _question
      end

      def execute!
        @question.ask do |response|
          PGit::Bilateral::HandleChooseStory.new(options(response)).execute!
        end
      end

      def stories
        @iterations.inject([]) { |accum, iteration| accum | iteration.stories }
      end

      private

      def options(new_response)
        {response: new_response, stories: stories, parent_question: @question}
      end

      def _question
        Question.new do |q|
          q.question = "Which story are you interested in?"
          q.options = [stories, :back]
          q.columns = [:index, :story_type, :estimate, :name, :current_state]
        end
      end

      def get_scope_hash(options)
        options.select {|k,v| k == :scope}
      end

      def options_has_valid_scope(options)
        [:done, :current, :current_backlog, :backlog].inject(false) {|accum, valid_scope| accum || options.fetch(:scope).to_sym == valid_scope}

      end
    end
  end
end
