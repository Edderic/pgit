#
#   Wrapper for a Pivotal Tracker story
#

module PGit
  class Story
    class << self
      def get(id, current_project)
        @id = id
        @project_id = current_project.id
        @api_token = current_project.api_token

        define_methods(get!)

        new
      end

      def define_methods(json)
        JSON.parse(json).each do |key, value|
          define_method key do
            value
          end
        end
      end

      def api_version
        "v5"
      end

      def get!
        request = `#{get_request}`
        if request.match(/error/)
          raise request
        else
          request
        end
      end

      def link
        "'https://www.pivotaltracker.com/services/#{api_version}/projects/#{@project_id}/stories/#{@id}'"
      end

      def get_request
        "curl -X GET -H 'X-TrackerToken: #{@api_token}' #{link}"
      end
    end
  end
end
