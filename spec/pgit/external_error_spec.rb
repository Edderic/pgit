require 'spec_helper'

describe 'PGit::ExternalError' do
  it 'should take in the response' do
    response = '{
      "code": "unfound_resource",
      "kind": "error",
      "error": "The object you tried to access could not be found.  It may have been removed by another user, you may be using the ID of another object type, or you may be trying to access a sub-resource at the wrong point in a tree."
    }'
    external_error = PGit::ExternalError.new(response)
    message = external_error.instance_eval { @message }

    expect(message).to eq(response)
  end

  it 'should inherit from PGit::Error' do
    ancestors = PGit::ExternalError.ancestors

    expect(ancestors).to include PGit::Error
  end
end
