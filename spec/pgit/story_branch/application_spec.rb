require 'pgit'
require 'pry'

describe 'PGit::StoryBranch::Application' do
  describe '#new' do
    describe 'options hash has start: 1234,
             and "config" => is some config' do
      it 'should call #start on an instance of StoryBranch' do
        global_opts = {}
        opts = { start: 1234 }
        args = {}
        fake_story_branch = instance_double('PGit::StoryBranch')
        fake_config_yaml = double('config_yaml')
        fake_configuration = instance_double('PGit::Configuration', to_yaml: fake_config_yaml)
        allow(fake_story_branch).to receive(:start)
        fake_get_request_results = double('json_response')
        fake_story_id = double('fake_story_id')

        fake_story = double('PGit::Story', id: fake_story_id)
        fake_story_class = class_double('PGit::Story', get: fake_get_request_results)
        fake_current_project = double('current_project')
        fake_name_parser = instance_double(PGit::StoryBranch::NameParser)
        allow(PGit::CurrentProject).to receive(:new).with(fake_config_yaml).and_return(fake_current_project)
        allow(PGit::StoryBranch::NameParser).to receive(:new).with(fake_story).and_return(fake_name_parser)
        allow(PGit::Story).to receive(:get).with(1234, fake_current_project).and_return(fake_story)
        allow(PGit::StoryBranch).to receive(:new).with(fake_name_parser).and_return(fake_story_branch)
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
