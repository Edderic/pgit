module PGit
  module Pivotal
    class Request
      def put!
        `curl -X PUT -H 'X-TrackerToken: #{@api_token}' -H 'Content-Type: application/json' -d '#{JSON.generate(to_hash)}' #{link}`
      end

      def api_version
        "v5"
      end

      def get!
        self.class.define_methods `curl -X GET -H 'X-TrackerToken: #{@api_token}' #{link}`
      end

      def link(sublink)
        "https://www.pivotaltracker.com/services/#{api_version}/#{sublink}"
      end

      def self.define_methods(json)
        JSON.parse(json).each do |key, value|
          define_method key do
            value
          end
        end
      end
    end
  end
end

