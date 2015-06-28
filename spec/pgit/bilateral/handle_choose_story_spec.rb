require 'spec_helper'

describe PGit::Bilateral::HandleChooseStory do
  it 'should create the branch' do
    some_story = double('PGit::Story')
    chosen_story = double('PGit::Story')
    options = {response: '1', stories: [some_story, chosen_story]}
    story_branch = double('PGit::StoryBranch', start: true)

    name_parser = double('PGit::StoryBranch::NameParser')
    allow(PGit::StoryBranch::NameParser).to receive(:new).with(chosen_story).and_return(name_parser)
    allow(PGit::StoryBranch).to receive(:new).with(name_parser).and_return(story_branch)
    handle_choose_story = PGit::Bilateral::HandleChooseStory.new(options)

    expect(story_branch).to have_received(:start)
  end
end
