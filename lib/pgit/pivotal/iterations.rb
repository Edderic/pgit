module PGit
  module Pivotal
    class Iterations < Pivotal::CollectionRequest
      def initialize(query='')
        # TODO: use better naming
        before_initialize
        @query = PGit::Pivotal::Request::Query.new(query)
      end

      def get!
        hashes_of_items.map do |item_hash|
          PGit::Pivotal::Iteration.new {|iter| iter.hash = item_hash}
        end
      end

      def sublink
        "projects/#{@project_id}/iterations/#{@query}"
      end

      private

      def hashes_of_items
        JSON.parse(get_request)
      end
    end
  end
end
