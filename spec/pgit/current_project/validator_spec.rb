require 'spec_helper'

describe 'PGit::CurrentProject::Validator' do
  it 'should raise an error if there are no matching projects' do
    matching_projects = []
    message = "None of the project paths matches the working directory"

    expect do
      PGit::CurrentProject::Validator.new(matching_projects)
    end.to raise_error(PGit::UserError, message)
  end
end
