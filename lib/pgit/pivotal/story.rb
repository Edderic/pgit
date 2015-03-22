require 'pgit'

module PGit
  module Pivotal
    class Story < PGit::Pivotal::IndividualRequest
      ATTRIBUTES = :estimate, :id, :project_id, :follower_ids, :group, :name, :description,
                    :story_type, :current_state, :accepted_at, :deadline, :requested_by_id,
                    :owner_ids, :labels, :label_ids, :before_id, :after_id, :integration_id,
                    :external_id

      attr_reader *ATTRIBUTES

      ATTRIBUTES.each do |attr|
        define_method "#{attr}=" do |value|
          @changed_attributes ||= []
          @changed_attributes << attr
          instance_variable_set("@#{attr}", value)
        end
      end

      def initialize(id=:no_story_id_given, &block)
        before_initialize
        @changed_attributes = []
        @id = id
        @follower_ids = []
        yield self if block_given?
      end

      def sublink
        "projects/#{@project_id}/stories/#{id}"
      end

      def attributes
        ATTRIBUTES
      end
    end
  end
end
