require 'spec_helper'

describe 'PGit::Command::UserError' do
  it 'should save the error' do
    message = "You did something dumb..."
    user_error = PGit::Command::UserError.new(message)

    expect(user_error.message).to eq message
  end

  it 'should be a PGit::Error' do
    message = "You did something dumb..."
    ancestors = PGit::Command::UserError.ancestors

    expect(ancestors).to include(PGit::Error)
  end
end
