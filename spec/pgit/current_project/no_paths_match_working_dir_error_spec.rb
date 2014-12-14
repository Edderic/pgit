require 'spec_helper'

describe 'PGit::CurrentProject::NoPathsMatchWorkingDirError' do
  it 'should have PGit::Error as an ancestor' do
    ancestors = PGit::CurrentProject::NoPathsMatchWorkingDirError.ancestors

    expect(ancestors).to include PGit::Error
  end

  it 'should have the appropriate message' do
    matches = []
    error = PGit::CurrentProject::NoPathsMatchWorkingDirError.new
    message = error.instance_eval { @message }

    expect(message).to eq "None of the project paths matches the working directory"
  end
end
