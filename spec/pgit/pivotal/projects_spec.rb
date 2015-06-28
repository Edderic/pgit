require 'spec_helper'

describe PGit::Pivotal::Projects do
  it 'should be a CollectionRequest' do
    expect(PGit::Pivotal::Projects.ancestors).to include(PGit::Pivotal::CollectionRequest)
  end

  describe 'get!' do
    it 'should instantiate a bunch of PGit::Pivotal::Project instances' do
      project = double('PGit::Pivotal::Project')
      allow(project).to receive(:hash=)
      get_request = double('get_request')
      api_token = 'some_api_token_123'
      hashes_of_items = [{'name' => 'PGit', 'kind' => 'project' }]
      allow(PGit::Pivotal::Project).to receive(:new).and_yield(project).and_return(project)
      allow_any_instance_of(PGit::Pivotal::CollectionRequest).to receive(:api_token).and_return(api_token)
      allow(JSON).to receive(:parse).with(get_request).and_return(hashes_of_items)

      projects = PGit::Pivotal::Projects.new
      allow(projects).to receive(:get_request).and_return(get_request)
      instantiated_projects = projects.get!
      expect(instantiated_projects).to include(project)
      expect(projects.api_token).to eq api_token
    end
  end

  describe 'with specific api_token' do
    it 'should instantiate a bunch of PGit::Pivotal::Project instances only associated with the token' do
      project = double('PGit::Pivotal::Project')
      allow(project).to receive(:hash=)
      get_request = double('get_request')
      hashes_of_items = [{'name' => 'PGit', 'kind' => 'project' }]
      allow(PGit::Pivotal::Project).to receive(:new).and_yield(project).and_return(project)
      allow(JSON).to receive(:parse).with(get_request).and_return(hashes_of_items)

      api_token = 'some_api_token_123'
      projects = PGit::Pivotal::Projects.new(api_token: api_token)
      expect(projects.api_token).to eq api_token
    end
  end

  describe 'sublink' do
    it 'should be "projects"' do
      projects = PGit::Pivotal::Projects.new
      expect(projects.sublink).to eq 'projects'
    end
  end
end
