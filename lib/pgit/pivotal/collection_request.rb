module PGit
  module Pivotal
    class CollectionRequest < Pivotal::Request
      def get!
        hashes_of_items.map do |item_hash|
          individual.new {|iter| iter.hash = item_hash}
        end
      end

      private

      def individual
        self.class.to_s[0...-1].constantize
      end

      def hashes_of_items
        JSON.parse(get_request)
      end
    end
  end
end
