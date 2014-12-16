require 'spec_helper'

describe 'PGit::Configuration::ProjectMissingError' do
  it 'should inherit from PGit::Error' do
    ancestors = PGit::Configuration::ProjectMissingError.ancestors

    expect(ancestors).to include (PGit::Error)
  end

  it 'should complain saying that a project must exist' do
    error_message = <<-ERROR
      /Users/edderic/some/config/path.yml needs at least one project.
      Please have the following layout:
      ---
      projects:
      - api_token: somepivotalatoken124
        id: '12345'
        path: ~/some/path/to/a/pivotal-git/project
      - api_token: somepivotalatoken124
        id: '23429070'
        path: ~/some/other/pivotal-git/project
    ERROR
    error_message.gsub!(/^\s{6}/,'')
    fake_path = "/Users/edderic/some/config/path.yml"
    project_missing_error = PGit::Configuration::ProjectMissingError.new(fake_path)
    message = project_missing_error.instance_eval{ @message }

    expect(message).to eq error_message
  end
end
