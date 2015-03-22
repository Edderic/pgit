module PGit
  module Pivotal
    class Iteration < Pivotal::IndividualRequest
      def initialize(&block)
        yield self
      end
    end
  end
end
