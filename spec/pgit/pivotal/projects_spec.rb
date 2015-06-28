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
      hashes_of_items = [{'name' => 'PGit', 'kind' => 'project' }]
      allow(PGit::Pivotal::Project).to receive(:new).and_yield(project).and_return(project)
      allow(JSON).to receive(:parse).with(get_request).and_return(hashes_of_items)

      projects = PGit::Pivotal::Projects.new
      allow(projects).to receive(:get_request).and_return(get_request)
      instantiated_projects = projects.get!
      expect(instantiated_projects).to include(project)
    end
  end

  describe 'sublink' do
    it 'should be "projects"' do
      projects = PGit::Pivotal::Projects.new
      expect(projects.sublink).to eq 'projects'
    end
  end
end
