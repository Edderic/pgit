require 'pgit'

module PGit
  module Pivotal
    class Story < PGit::Pivotal::IndividualRequest
      attr_accessor :estimate

      def initialize(project, story_id=:story_id_not_given)
        @id = story_id
        @project_id = project.id
        @api_token = project.api_token
      end

      def to_hash
        {
          "estimate" => estimate
        }
      end

      def sublink
        "projects/#{@project_id}/stories/#{@id}"
      end
    end
  end
end
