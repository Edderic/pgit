require 'spec_helper'

describe 'PGit::Project::Application' do
  describe '#path' do
    it 'defaults to the current directory if not provided' do
      fake_api_token = double('fake_api_token')
      fake_path = double('fake_path')
      global_opts, opts, args = {}, { api_token: fake_api_token }, []
      allow(Dir).to receive(:pwd).and_return(fake_path)
      app = PGit::Project::Application.new(global_opts, opts, args)

      expect(app.path).to eq fake_path
    end

    it 'gets the directory of interest from opts' do
      fake_path = double('fake_path')
      fake_api_token = double('fake_api_token')
      global_opts, opts, args = {}, { path: fake_path, api_token: fake_api_token }, []
      app = PGit::Project::Application.new(global_opts, opts, args)

      expect(app.path).to eq fake_path
    end
  end

  describe '#api_token' do
    it 'gets api_token from opts' do
      api_token = double('api_token')
      global_opts, opts, args = {}, { api_token: api_token }, []
      app = PGit::Project::Application.new(global_opts, opts, args)

      expect(app.api_token).to eq api_token
    end

    it 'defaults to :no_api_token_provided' do
      global_opts, opts, args = {}, {}, []
      app = PGit::Project::Application.new(global_opts, opts, args)

      expect(app.api_token).to eq :no_api_token_provided
    end
  end
end
