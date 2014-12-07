require_relative '../lib/pivotal'

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
  end
end
