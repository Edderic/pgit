require 'spec_helper'

describe 'PGit::Error::User' do
  it 'should save the error' do
    message = "You did something dumb..."
    user_error = PGit::Error::User.new(message)

    expect(user_error.message).to eq message
  end

  it 'should be a PGit::Error' do
    message = "You did something dumb..."
    ancestors = PGit::Error::User.ancestors

    expect(ancestors).to include(PGit::Error)
  end
end
