require 'pgit'

module PGit
  module Bilateral
    class Story
      include Interactive
      def initialize(options)
        raise PGit::Error::User, "Invalid options. See `pgit iteration -h` for valid options." unless options_has_valid_scope(options)

        @iterations_obj = PGit::Pivotal::Iterations.new(get_scope_hash(options))
        @iterations = @iterations_obj.get!
      end

      def execute!
        which_question.ask do |which_response|
        end
      end

      def stories
        @iterations.inject([]) { |accum, iteration| accum | iteration.stories }
      end

      def which_question
        Question.new do |which_question|
          which_question.question = "Which story are you interested in?"
          which_question.options = [stories, :back]
          which_question.columns = [:index, :story_type, :estimate, :name, :current_state]
        end
      end

      private

      def get_scope_hash(options)
        options.select {|k,v| k == :scope}
      end

      def options_has_valid_scope(options)
        [:done, :current, :current_backlog, :backlog].inject(false) {|accum, valid_scope| accum || options.fetch(:scope).to_sym == valid_scope}

      end
    end
  end
end
