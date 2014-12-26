require 'spec_helper'

describe 'PGit::Command::EmptyError' do
  it 'gives instructions' do
    empty_error = PGit::Command::EmptyError.new
    expected_message = "No commands are listed for this project. Run `pgit command --add --name='command_name' --steps='step 1, step2'` to add a command for this project. You can also edit ~/.pgit.rc.yml directly"
    message = empty_error.message

    expect(message).to eq expected_message
  end
end
