require 'spec_helper'

describe 'PGit::Project::Application' do
  describe '#exists?' do
    it 'delegates to @project' do
      global_opts = {}
      opts = { 'path' => '/some/path',
               'api_token' => 'someapitoken1234',
               'id' => 12345}
      args = []
      configuration = instance_double('PGit::Configuration')
      allow(PGit::Configuration).to receive(:new).and_return(configuration)
      project_exists = double('response')
      allow_any_instance_of(PGit::Project).to receive(:exists?).and_return(project_exists)
      app = PGit::Project::Application.new(global_opts, opts, args)

      expect(app.exists?).to eq project_exists
    end

    it 'delegates to @project' do
      global_opts = {}
      opts = { 'path' => '/some/path',
               'api_token' => 'someapitoken1234',
               'id' => 12345}
      args = []
      configuration = instance_double('PGit::Configuration')
      allow(PGit::Configuration).to receive(:new).and_return(configuration)
      project_save = double('response')
      allow_any_instance_of(PGit::Project).to receive(:save!).and_return(project_save)
      app = PGit::Project::Application.new(global_opts, opts, args)

      expect(app.save!).to eq project_save
    end
  end
end
