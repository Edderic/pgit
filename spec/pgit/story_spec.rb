require 'pgit'

describe 'PGit::Story' do
  describe '#get!' do
    it 'should execute the proper cURL string' do
      story_id = '123'
      project_id = '321'
      api_token = 'abc10xyz'
      pivotal_story = PGit::Story.new(story_id, project_id, api_token)
      get_request = "curl -X GET -H 'X-TrackerToken: abc10xyz' 'https://www.pivotaltracker.com/services/v5/projects/321/stories/123'"
      allow(pivotal_story).to receive(:`).with get_request

      pivotal_story.get!

      expect(pivotal_story).to have_received(:`).with get_request
    end

    describe 'if there is an error' do
      it 'should raise an error' do
        story_id = '123'
        project_id = '321'
        api_token = 'abc10xyz'
        pivotal_story = PGit::Story.new(story_id, project_id, api_token)
        get_request = "curl -X GET -H 'X-TrackerToken: abc10xyz' 'https://www.pivotaltracker.com/services/v5/projects/321/stories/123'"
        fake_json_str_with_error = <<-ERROR_JSON
          {
            "code": "unfound_resource",
                    "kind": "error",
                    "error": "The object you tried to access could not be found.  It may have been removed by another user, you may be using the ID of another object type, or you may be trying to access a sub-resource at the wrong point in a tree."
          }
        ERROR_JSON

        allow(pivotal_story).to receive(:`).with(get_request).and_return fake_json_str_with_error

        expect{ pivotal_story.get! }.to raise_error(fake_json_str_with_error)
      end
    end
  end
end
