module PGit
  module Pivotal
    class Request
      def before_initialize
        @project_id = current_project.id
      end

      def api_version
        "v5"
      end

      def get_request
        `curl -X GET -H 'X-TrackerToken: #{api_token}' #{link}`
      end

      def link
        "https://www.pivotaltracker.com/services/#{api_version}/#{sublink}"
      end

      def api_token
        current_project.api_token
      end

      def current_project
        PGit::CurrentProject.new(configuration)
      end

      def configuration
        PGit::Configuration.new
      end
    end
  end
end
