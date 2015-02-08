require 'spec_helper'

describe 'PGit::CurrentProject' do
  it 'instantiates the PGit::Project that exists in the config file and whose path matches the working directory' do
    matching_path = '/some/matching_path'
    matching_project = instance_double('PGit::Project',
                                      path: matching_path)
    projects = [matching_project]
    configuration = instance_double('PGit::Configuration',
                                    projects: projects)
    allow(Dir).to receive(:pwd).and_return(matching_path)
    proj = PGit::CurrentProject.new(configuration)

    expect(proj.path).to eq matching_path
  end
end
