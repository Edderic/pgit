module PGit
  module Bilateral
    class HandleBack
      def initialize(options)
        @parent_question = options.fetch(:parent_question)
        @response = options.fetch(:response)
      end

      def execute!
        if response_can_be_handled?
          @parent_question.reask!
        end
      end

      private

      def response_can_be_handled?
        @response.back?
      end
    end
  end
end
