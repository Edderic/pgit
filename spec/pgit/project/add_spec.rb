require 'spec_helper'

describe 'PGit::Project::Add' do
  # describe 'when path is not given' do
    # it 'defaults to the working directory' do
      # app = instance_double('PGit::Project::Application')
      # fake_path = double('fake_path')
      # allow(Dir).to receive(:pwd).and_return(fake_path)
#
      # add = PGit::Project::Add.new(app)
      # expect(add.path).to eq fake_path
    # end
  # end
  #
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
end
