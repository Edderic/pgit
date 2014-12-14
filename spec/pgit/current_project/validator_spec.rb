require 'spec_helper'

describe 'PGit::CurrentProject::Validator' do
  it 'should raise an error if there are no matching projects' do
    matching_projects = []

    expect do
      PGit::CurrentProject::Validator.new(matching_projects)
    end.to raise_error PGit::CurrentProject::NoPathsMatchWorkingDirError
  end
end
