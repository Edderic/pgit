module PGit
  module Pivotal
    class Request
      class Query
        def initialize(args={})
          @args = args
        end

        def to_s
          query_with_extra_ampersand[0...query_with_extra_ampersand.length-1]
        end

        private

        def query_with_extra_ampersand
          hash_strings.inject("?") { |accum, item| accum + item }
        end

        def hash_strings
          @args.map { |key, value| "#{key}=#{value}&" }
        end
      end
    end
  end
end
