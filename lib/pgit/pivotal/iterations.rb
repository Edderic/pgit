module PGit
  module Pivotal
    class Iterations < Pivotal::CollectionRequest
      def initialize(project, query='')
        @api_token = project.api_token
        @project_id = project.id
        @query = PGit::Pivotal::Request::Query.new(query)
      end

      def get!
        iterations.map do |iteration_hash|
          PGit::Pivotal::Iteration.new {|iter| iter.hash = iteration_hash}
        end
      end

      def sublink
        "projects/#{@project_id}/iterations/#{@query}"
      end

      private

      def iterations
        JSON.parse(get_request)
      end
    end
  end
end
