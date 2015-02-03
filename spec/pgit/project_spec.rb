require 'spec_helper'

describe 'PGit::Project' do
  describe '#path' do
    it 'returns the path' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => {} }
      proj = PGit::Project.new(project_hash)
      expect(proj.path).to eq project_hash.fetch('path')
    end
  end

  describe '#api_token' do
    it 'returns the api_token' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => {} }
      proj = PGit::Project.new(project_hash)
      expect(proj.api_token).to eq project_hash.fetch('api_token')
    end
  end

  describe '#has_path?(path)' do
    it 'returns true if the paths are the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => {} }
      proj = PGit::Project.new(project_hash)
      puts "proj.methods(false)"
      puts proj.methods(false)

      expect(proj).to be_has_path(project_hash.fetch('path'))
    end

    it 'returns false if the paths are not the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => {} }
      proj = PGit::Project.new(project_hash)

      expect(proj).not_to be_has_path('some/other/path')
    end
  end

  describe '#has_api_token?(api_token)' do
    it 'returns true if the api_tokens are the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => {} }
      proj = PGit::Project.new(project_hash)

      expect(proj).to be_has_api_token(project_hash.fetch('api_token'))
    end

    it 'returns false if the api_tokens are not the same' do
      project_hash =  { "path" => "/Therapy-Exercises-Online/some_other_project",
                        "id" => 12345,
                        "api_token" => "astoeuh",
                        "commands" => {} }
      proj = PGit::Project.new(project_hash)

      expect(proj).not_to be_has_api_token('some/other/api_token')
    end
  end

  describe '#has_id?(id)' do
  end

  describe '#commands' do
  end

  describe '#to_hash' do
  end
end
