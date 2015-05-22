require 'pgit'

module PGit
  module Validators
    class ProjectValidator < ActiveModel::Validator
      def validate(project)
        project.get!

        unless project.respond_to?(:kind)
          project.errors[:curl] << "is not able to do the request. Please check your internet connection."
        end
#
        if project.respond_to?(:kind) && project.kind == 'error'
          project.errors[:base] << "Project api_token or id is not valid."
          puts project.errors.full_messages
        end
      end
    end
  end
end
