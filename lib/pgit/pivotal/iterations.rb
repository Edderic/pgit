module PGit
  module Pivotal
    class Iterations < Pivotal::CollectionRequest
      def initialize(query='')
        # TODO: use better naming
        before_initialize
        @query = PGit::Pivotal::Request::Query.new(query)
      end

      def sublink
        "projects/#{@project_id}/iterations/#{@query}"
      end
    end
  end
end
