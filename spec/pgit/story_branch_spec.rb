require 'spec_helper'

describe 'PGit::StoryBranch' do
  describe '#id' do
    it 'should return the story_id' do
      fake_parsed_branch_name = 'bring-me-da-coconut-1234'
      fake_story_id = '1234'
      name_parser = instance_double('PGit::StoryBranch::NameParser',
                                    story_id: fake_story_id,
                                    name: fake_parsed_branch_name)
      allow(name_parser).to receive(:name).and_return(fake_parsed_branch_name)
      story_branch = PGit::StoryBranch.new(name_parser)
      story_branch_id = story_branch.id

      expect(story_branch_id).to eq '1234'
    end
  end


  describe '#start' do
    it 'should call the backticks on the Kernel with the proper branch name' do
      fake_parsed_json = { "name" => "Bring me the passengers",
                           "id" => 555
      }
      fake_json_response = double('fake_json_response')
      fake_story_id = 555
      fake_story_name = "bring-me-passengers-555"
      allow(JSON).to receive(:parse).with(fake_json_response).and_return(fake_parsed_json)
      fake_name_parser = instance_double('PGit::StoryBranch::NameParser',
                                         story_id: fake_story_id,
                                         name: fake_story_name
                                         )
      checkout_branch_command = "git checkout -b bring-me-passengers-555"
      pg_branch = PGit::StoryBranch.new(fake_name_parser)
      allow(pg_branch).to receive(:`).with(checkout_branch_command)

      pg_branch.start

      expect(pg_branch).to have_received(:`).with(checkout_branch_command)
    end
  end

  describe '#name' do
    it 'should return the result of the parsed branch name' do
      fake_parsed_json = { "name" => "Bring me the passengers",
                           "id" => 555
      }
      fake_json_response = double('fake_json_response')
      allow(JSON).to receive(:parse).with(fake_json_response).and_return(fake_parsed_json)
      checkout_branch_command = "git checkout -b bring-me-passengers-555"
      fake_parsed_branch_name = double('parsed_branch_name')
      fake_name_parser = double('name_parser', name: fake_parsed_branch_name)


      pg_branch = PGit::StoryBranch.new(fake_name_parser)

      branch_name = pg_branch.name

      expect(branch_name).to eq fake_parsed_branch_name
    end
  end

  # describe '#new without any arguments' do
    # describe 'on a branch without a story id' do
      # describe '#id' do
        # it 'should throw an error' do
          # fake_current_branch_name = "master"
          # error_message = "Error: #{fake_current_branch_name} does not have a story id at the end"
          # allow(PGit::CurrentBranch).to receive(:name).and_return(fake_current_branch_name)
#
          # expect{PGit::StoryBranch.new}.to raise_error error_message
        # end
      # end
    # end
#
    # describe 'on a branch with a story id' do
      # describe '#id' do
        # it 'should return the id' do
          # fake_current_branch_name = "some-feature-branch-12345678"
          # allow(PGit::CurrentBranch).to receive(:name).and_return(fake_current_branch_name)
          # error_message = "Error: #{fake_current_branch_name} does not have a story id at the end"
          # story_branch = PGit::StoryBranch.new
          # story_branch_id = story_branch.id
#
          # expect(story_branch_id).to eq('12345678')
        # end
      # end
    # end
  # end
end
