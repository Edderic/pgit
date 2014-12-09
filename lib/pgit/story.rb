#
#   Wrapper for a Pivotal Tracker story
#
# - id: story id
# - project_id: found in the pivotal tracker settings page
# - api_token: found in the PT settings page

module PGit
  class Story
    def initialize(id, current_project)
      @id = id
      @project_id = current_project.id
      @api_token = current_project.api_token
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
