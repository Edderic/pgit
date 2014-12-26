require 'spec_helper'

describe 'PGit::Command::NotFoundError' do
  describe '#new' do
    it 'says that the command does not exist' do
      command = 'non_existent_command'
      error = PGit::Command::NotFoundError.new(command)

      expect(error.message).to eq "Command 'non_existent_command' does not exist. Run 'pgit command --list' to see the available custom commands."
    end
  end
end
