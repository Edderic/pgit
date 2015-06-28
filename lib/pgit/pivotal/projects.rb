require 'pgit'

module PGit
  module Pivotal
    class Projects < CollectionRequest
      def initialize(*args, &block)
        @api_token = args.first[:api_token] unless args.empty?
        yield self if block_given?
      end

      def api_token
        @api_token ? @api_token : super
      end

      def sublink
        'projects'
      end
    end
  end
end
