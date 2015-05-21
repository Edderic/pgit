module PGit
  module Pivotal
    class IndividualRequest < Pivotal::Request
      def put!
        require 'byebug'; byebug
        `curl -X PUT -H 'X-TrackerToken: #{api_token}' -H 'Content-Type: application/json' -d '#{JSON.generate(to_hash)}' #{link}`
        @changed_attributes = []
      end

      def get!
        define_methods get_request
      end

      def define_methods(json)
        JSON.parse(json).each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def to_hash
        @changed_attributes.inject(Hash.new) {|accum, key| accum[key] = send(key); accum }
      end

      def hash=(hash)
        hash.each do |key, value|
          if key == 'stories'
            define_singleton_method key do
              value.map do |story_hash|
                PGit::Pivotal::Story.new do |s|
                  s.hash = story_hash
                end
              end
            end
          else
            define_singleton_method key do
              value
            end
          end
        end
      end
    end
  end
end

