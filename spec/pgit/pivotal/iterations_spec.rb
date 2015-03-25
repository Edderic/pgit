require 'spec_helper'

describe PGit::Pivotal::Iterations do
  describe '#get!' do
    it 'makes the correct sublink' do
      project = instance_double('PGit::Project', id: 123, api_token: 'someapitoken')
      allow(PGit::CurrentProject).to receive(:new).and_return(project)
      query = instance_double('PGit::Pivotal::Request::Query', to_s: "?scope=current_backlog")
      hash_query = {scope: :current_backlog}
      allow(PGit::Pivotal::Request::Query).to receive(:new).with(hash_query).and_return(query)
      iterations = PGit::Pivotal::Iterations.new(hash_query)

      expect(iterations.sublink).to eq "projects/123/iterations/?scope=current_backlog"
    end

    it 'instantiates iterations' do
      iterations_file = File.read(File.join(PGit.root, 'spec', 'fixtures', 'iterations'))
      iterations_json = JSON.parse(iterations_file)
      first_iteration_json = iterations_json.first
      last_iteration_json = iterations_json.last
      first_iteration = instance_double('PGit::Pivotal::Iteration')
      last_iteration = instance_double('PGit::Pivotal::Iteration')
      fake_iterations = [first_iteration, last_iteration]
      iteration_config = double('config', :hash= => nil)
      allow(PGit::Pivotal::Iteration).to receive(:new).and_yield(iteration_config).and_return(first_iteration, last_iteration)
      project = instance_double('PGit::Project', api_token: double('api_token'), id: double('id'))
      allow(PGit::CurrentProject).to receive(:new).and_return(project)
      iterations_instance = PGit::Pivotal::Iterations.new(project)
      allow(iterations_instance).to receive(:get_request).and_return(iterations_file)

      iterations = iterations_instance.get!

      expect(iterations.first).to eq first_iteration
      expect(iterations.last).to eq last_iteration
    end
  end
end
