require 'pgit'

describe 'PGit::StoryBranch::Application' do
  describe '#new' do
    describe 'options hash has start: 1234,
             and "config" => is some config' do
      it 'should call #start on an instance of StoryBranch' do
        global_opts = {}
        opts = { start: 1234 }
        args = {}
        fake_story_branch = double('story_branch')
        fake_config_yaml = double('config_yaml')
        fake_configuration = double('config', to_yaml: fake_config_yaml)
        allow(fake_story_branch).to receive(:start)
        allow(PGit::StoryBranch).to receive(:new).with(1234, fake_config_yaml).and_return(fake_story_branch)
        allow(PGit::Configuration).to receive(:new).and_return(fake_configuration)

        PGit::StoryBranch::Application.new(global_opts, opts, args)

        expect(fake_story_branch).to have_received(:start)
      end
    end

    describe 'options passed in have keys that only point to nil or false' do
      it 'should show the helpfile' do
        global_opts = {}
        opts = { start: nil, finish: false }
        args = {}
        story_branch_help_call = 'pgit story_branch --help'
        allow_any_instance_of(PGit::StoryBranch::Application).to receive(:`).with(story_branch_help_call)

        story_branch = PGit::StoryBranch::Application.new(global_opts, opts, args)

        expect(story_branch).to have_received(:`).with(story_branch_help_call)
      end
    end
  end
end
