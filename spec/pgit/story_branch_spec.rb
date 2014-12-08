require 'pgit'

describe 'PGit::StoryBranch' do
  describe '#new(story_id, config_yaml)' do
    it 'should call .to_yaml on the configuration' do
      fake_project_1 =  { "path" => "~/Therapy-Exercises-Online/some_other_project",
                          "id" => 12345,
                          "api_token" => "astoeuh" }
      fake_project_2 =  { "path" => "~/Therapy-Exercises-Online",
                          "id" => 19191,
                          "api_token" => "astoeuh" }
      fake_projects = [ fake_project_1, fake_project_2 ]
      fake_config_yaml = { "projects" => fake_projects }
      fake_story_id = '0123443'

      fake_project_id = 19191
      fake_api_token = 'astoeuh'
      fake_current_project = double('current_project',
                                    id: fake_project_id,
                                    api_token: fake_api_token)

      allow(PGit::CurrentProject).
        to receive(:new).with(fake_config_yaml).
        and_return(fake_current_project)

      allow(PGit::Story).to receive(:new).
        with(fake_story_id, fake_project_id, fake_api_token)

      PGit::StoryBranch.new(fake_story_id, fake_config_yaml)

      expect(PGit::Story).to have_received(:new).with(fake_story_id, fake_project_id, fake_api_token)
    end

    describe '#id' do
      it 'should return the story_id' do

        expect(id).to
      end
    end
  end


  describe '#start' do
    it 'should call the backticks on the Kernel with the proper branch name' do
      fake_project_1 =  { "path" => "~/Therapy-Exercises-Online/some_other_project",
                          "id" => 12345,
                          "api_token" => "astoeuh" }
      fake_project_2 =  { "path" => "~/Therapy-Exercises-Online",
                          "id" => 19191,
                          "api_token" => "astoeuh" }
      fake_projects = [ fake_project_1, fake_project_2 ]
      fake_config_yaml = { "projects" => fake_projects }
      fake_story_id = '0123443'

      fake_project_id = 19191
      fake_api_token = 'astoeuh'
      fake_current_project = double('current_project',
                                    id: fake_project_id,
                                    api_token: fake_api_token)

      fake_json_response = '{
   "created_at": "2014-11-18T12:00:00Z",
      "current_state": "unstarted",
         "description": "ignore the droids",
            "estimate": 2,
               "id": 555,
                  "kind": "story",
                     "labels":
                        [
   ],
   "name": "Bring me the passengers",
      "owner_ids":
         [
   ],
   "project_id": 19191,
      "requested_by_id": 101,
         "story_type": "feature",
            "updated_at": "2014-11-18T12:00:00Z",
               "url": "http://localhost/story/show/555"
               }'
      fake_story = double('story', get!: fake_json_response)

      allow(PGit::CurrentProject).
        to receive(:new).with(fake_config_yaml).
        and_return(fake_current_project)

      allow(PGit::Story).to receive(:new).
        with(fake_story_id, fake_project_id, fake_api_token).
        and_return(fake_story)

      checkout_branch_command = "git checkout -b bring-me-passengers-555"

      pg_branch = PGit::StoryBranch.new(fake_story_id, fake_config_yaml)

      allow(pg_branch).to receive(:`).with(checkout_branch_command)

      pg_branch.start

      expect(pg_branch).to have_received(:`).with(checkout_branch_command)
    end
  end

  describe '#new without any arguments' do
    describe 'on a branch without a story id' do
      describe '#id' do
        it 'should throw an error' do
          fake_current_branch_name = "master"
          error_message = "Error: #{fake_current_branch_name} does not have a story id at the end"
          allow(PGit::CurrentBranch).to receive(:name).and_return(fake_current_branch_name)

          expect{PGit::StoryBranch.new}.to raise_error error_message
        end
      end
    end

    describe 'on a branch with a story id' do
      describe '#id' do
        it 'should return the id' do
          fake_current_branch_name = "some-feature-branch-12345678"
          allow(PGit::CurrentBranch).to receive(:name).and_return(fake_current_branch_name)
          error_message = "Error: #{fake_current_branch_name} does not have a story id at the end"
          story_branch = PGit::StoryBranch.new
          story_branch_id = story_branch.id

          expect(story_branch_id).to eq('12345678')
        end
      end
    end
  end
end
