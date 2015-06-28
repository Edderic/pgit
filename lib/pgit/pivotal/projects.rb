require 'pgit'

module PGit
  module Pivotal
    class Projects < CollectionRequest
      def sublink
        'projects'
      end
    end
  end
end
