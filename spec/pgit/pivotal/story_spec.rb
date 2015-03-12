require 'spec_helper'

describe 'PGit::Pivotal::Story' do
  describe '#get!' do
    it 'should generate the story' do
      story_id = '123'
      current_project = double('current_project', id: '321', api_token: 'abc10xyz')
      get_request = "curl -X GET -H 'X-TrackerToken: abc10xyz' https://www.pivotaltracker.com/services/v5/projects/321/stories/123"
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

      story = PGit::Pivotal::Story.new(current_project, story_id)
      allow(story).to receive(:`).with(get_request).and_return(fake_good_json)
      allow_any_instance_of(PGit::Pivotal::Request).to receive(:`).with(get_request).and_return(fake_good_json)
      story.get!

      expect(story.name).to eq "Bring me the passengers"
      expect(story.description).to eq "ignore the droids"
    end
  end

  describe '#put' do
    it 'updates the story' do
      story_id = '123'
      current_project = double('current_project', id: '321', api_token: 'abc10xyz')
      put_request = "curl -X PUT -H 'X-TrackerToken: abc10xyz' -H 'Content-Type: application/json' -d '{\"estimate\":2}' https://www.pivotaltracker.com/services/v5/projects/321/stories/123"
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

      story = PGit::Pivotal::Story.new(current_project, story_id)
      allow(story).to receive(:`)
      story.estimate = 2
      story.put!

      expect(story).to have_received(:`).with(put_request)
    end
  end

  describe '#current_state' do
    it 'estimate' do
      {
        "kind":"story",
        "id":87947638,
        "project_id":1228944,
        "name":"pgit proj add tests connection to see if api_token and id are correct",
        "description":"If CURL issue (no internet connection),
        ask user if user wants to have it saved anyway into the configuration.\n\nif wrong,
        should reject saving the project into the config file: \"Something is wrong with either the id or api_token. Please check them and try again.\"\n\nIf correct,
        should notify: 'Successfully added project!'\n\n ",
        "story_type":"bug",
        "current_state":"started",
        "requested_by_id":1121520,
        "owned_by_id":1121520,
        "owner_ids":[1121520],
        "labels":[
          {"kind":"label",
                   "id":10378716,
                   "project_id":1228944,
                   "name":"project",
                   "created_at":"2015-01-05T11:42:35Z",
                   "updated_at":"2015-01-05T11:42:35Z"}
          ],
         "created_at":"2015-02-09T16:14:45Z",
         "updated_at":"2015-02-23T12:20:02Z",
         "url":"https://www.pivotaltracker.com/story/show/87947638"
      }
    end
  end
end
