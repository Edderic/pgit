require 'pgit'

describe 'PGit::Story' do
  describe '#get!' do
    it 'should execute the proper cURL string' do
      story_id = '123'
      project_id = '321'
      api_token = 'abc10xyz'
      pivotal_story = PGit::Story.new(story_id, project_id, api_token)
      get_request = "curl -X GET -H 'X-TrackerToken: abc10xyz' 'https://www.pivotaltracker.com/services/v5/projects/321/stories/123'"
      fake_good_json = <<-GOOD_JSON
      {
         "created_at": "2014-11-25T12:00:00Z",
         "current_state": "unstarted",
         "description": "ignore the droids",
         "estimate": 2,
         "id": 555,
         "kind": "story",
         "labels": [],
         "name": "Bring me the passengers",
         "owner_ids": [],
         "project_id": 99,
         "requested_by_id": 101,
         "story_type": "feature",
         "updated_at": "2014-11-25T12:00:00Z",
         "url": "http://localhost/story/show/555"
      }
      GOOD_JSON
      allow(pivotal_story).to receive(:`).with(get_request).and_return(fake_good_json)

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
