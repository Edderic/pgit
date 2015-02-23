require 'spec_helper'

describe 'PGit::Pivotal::Story' do
  describe '#get' do
    it 'should generate the story' do
      story_id = '123'
      current_project = double('current_project', id: '321', api_token: 'abc10xyz')
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
      allow(PGit::Pivotal::Story).to receive(:`).with(get_request).and_return(fake_good_json)

      story = PGit::Pivotal::Story.get(story_id, current_project)

      expect(story.name).to eq "Bring me the passengers"
      expect(story.description).to eq "ignore the droids"
    end
  end
end
