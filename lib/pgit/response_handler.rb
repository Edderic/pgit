module PGit
  class ResponseHandler
    attr_reader :question
    def execute!
      if response_can_be_handled?
        @question.ask do |response|
          @response_handlers.each {|handler| handler.new(options(response)).execute! }
        end
      end
    end

    def response_can_be_handled?
      true
    end
  end
end
