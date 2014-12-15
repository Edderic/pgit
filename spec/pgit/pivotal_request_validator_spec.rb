require 'spec_helper'

describe 'PGit::PivotalRequestValidator' do
  describe 'when the request has an "error" but "kind" is not "error"' do
    it 'should not raise an error' do
      request = <<-REQUEST
        {
          "kind": "story",
          "id": 84538682,
          "project_id": 1228944,
          "name": "Don't just use regex to match the whole JSON string response for the word \"error\".",
          "description": " If \"kind\" of the get response is \"error\", throw an error.",
          "story_type": "bug",
          "current_state": "started",
          "requested_by_id": 1121520,
          "owned_by_id": 1121520,
          "owner_ids": [ 1121520 ],
          "labels": [ ],
          "created_at": "2014-12-14T15:11:46Z",
          "updated_at": "2014-12-15T12:04:13Z",
          "url": "https://www.pivotaltracker.com/story/show/84538682"
        }
      REQUEST

      expect do
        PGit::PivotalRequestValidator.new(request)
      end.not_to raise_error
    end
  end

  describe 'when the request has "kind": "error"' do
    it 'should raise an error' do
      request = <<-REQUEST
        {
          "code": "unfound_resource",
          "kind": "error",
          "error": "The object you tried to access could not be found.  It may have been removed by another user, you may be using the ID of another object type, or you may be trying to access a sub-resource at the wrong point in a tree."
        }
      REQUEST

      expect do
        PGit::PivotalRequestValidator.new(request)
      end.to raise_error(PGit::ExternalError)
    end
  end

  describe 'when the request has no "kind"' do
    it 'should raise a PGit::ExternalError' do
      request = <<-REQUEST
        some unrecognizable request
      REQUEST

      expect do
        PGit::PivotalRequestValidator.new(request)
      end.to raise_error(PGit::ExternalError)
    end
  end

  describe '#request' do
    it 'should return the passed request when there is no error' do
      request = <<-REQUEST
        {
          "kind": "story",
          "id": 84538682,
          "project_id": 1228944,
          "name": "Don't just use regex to match the whole JSON string response for the word \"error\".",
          "description": " If \"kind\" of the get response is \"error\", throw an error.",
          "story_type": "bug",
          "current_state": "started",
          "requested_by_id": 1121520,
          "owned_by_id": 1121520,
          "owner_ids": [ 1121520 ],
          "labels": [ ],
          "created_at": "2014-12-14T15:11:46Z",
          "updated_at": "2014-12-15T12:04:13Z",
          "url": "https://www.pivotaltracker.com/story/show/84538682"
        }
      REQUEST

      validator = PGit::PivotalRequestValidator.new(request)
      filtered_request = validator.request

      expect(filtered_request).to eq request
    end
  end
end
