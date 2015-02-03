require 'spec_helper'

describe 'PGit::Project::Add' do
  describe 'user is on a project path that already exists' do
    it 'raises an error' do
      app = instance_double('PGit::Project::Application',
                            has_project_path?: true)
      expect{PGit::Project::Add.new(app)}.to raise_error(PGit::Error::User, 'Project path already exists')
    end
  end

  describe '#path' do
    it 'gets the path from app' do
      fake_path = double('path')
      fake_api_token = double('api_token')
      app = instance_double('PGit::Project::Application',
                            api_token: fake_api_token,
                            path: fake_path)
      add = PGit::Project::Add.new(app)

      expect(add.path).to eq fake_path
    end
  end

  describe '#api_token' do
    it 'gets the api_token from app' do
      fake_api_token = double('api_token')
      fake_path = double('path')
      app = instance_double('PGit::Project::Application',
                            api_token: fake_api_token,
                            path: fake_path)
      add = PGit::Project::Add.new(app)

      expect(add.api_token).to eq fake_api_token
    end
  end

  describe '#execute!' do

  end
end
