module PGit
  class PivotalRequestValidator
    attr_reader :request

    def initialize(request)
      @request = request

      validate
    end

    private

    def validate
      if no_kind?
        raise PGit::Error::External.new(@request)
      end
    end

    def kind_error?
      @request.match(/"kind": "error"/)
    end

    def no_kind?
      !@request.match(/"kind"/)
    end
  end
end
