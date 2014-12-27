require 'spec_helper'

describe 'PGit::Command::EmptyError' do
  it 'gives instructions' do
    empty_error = PGit::Command::EmptyError.new
    expected_message = "No commands are listed for this project. Run `pgit command add --help` for more info."
    message = empty_error.message

    expect(message).to eq expected_message
  end
end
