require 'spec_helper'

describe PGit::Bilateral::Story do
  describe 'scope is bad scope' do
    it 'should raise an error' do
      project = instance_double('PGit::Project', id: 12345, api_token: 'someapitoken')
      options = { scope: 'blah' }
      query = {scope: :current}
      story_1 = instance_double('PGit::Story',
                                story_type: 'chore',
                                estimate: 2,
                                name: 'some story',
                                current_state: 'unstarted')
      story_2 = instance_double('PGit::Story',
                                story_type: 'feature',
                                estimate: 3,
                                name: 'some other story',
                                current_state: 'unstarted')
      stories = [story_1, story_2]
      iteration_1 = double('PGit::Pivotal::Iteration', stories: stories)
      iterations = [iteration_1]
      iterations_obj = double('PGit::Pivotal::Iterations', get!: iterations)
      allow(PGit::Pivotal::Iterations).
        to receive(:new).with(query).and_return(iterations_obj)
      config = double('config', :question= => nil, :options= => nil, :columns= => nil)
      question = instance_double('Interactive::Question', ask: nil)
      allow(Interactive::Question).to receive(:new).and_yield(config).and_return(question)
      expect{ PGit::Bilateral::Story.new(options) }.to raise_error(PGit::Error::User, 'Invalid options. See `pgit iteration -h` for valid options.')
    end
  end

  describe '#execute!' do
    describe 'scope is done' do
      it 'should show the done ones' do
        project = instance_double('PGit::Project', id: 12345, api_token: 'someapitoken')
        options = { scope: :done }
        query = {scope: :done}
        story_1 = instance_double('PGit::Story',
                                  story_type: 'chore',
                                  estimate: 2,
                                  name: 'some story',
                                  current_state: 'accepted')
        story_2 = instance_double('PGit::Story',
                                  story_type: 'feature',
                                  estimate: 3,
                                  name: 'some other story',
                                  current_state: 'accepted')
        stories = [story_1, story_2]
        iteration_1 = double('PGit::Pivotal::Iteration', stories: stories)
        iterations = [iteration_1]
        iterations_obj = double('PGit::Pivotal::Iterations', get!: iterations)
        allow(PGit::Pivotal::Iterations).
          to receive(:new).with(query).and_return(iterations_obj)
        config = double('config', :question= => nil, :options= => nil, :columns= => nil)
        question = instance_double('Interactive::Question', ask: nil)
        allow(Interactive::Question).to receive(:new).and_yield(config).and_return(question)
        interactive_story = PGit::Bilateral::Story.new(options)
        interactive_story.execute!

        expect(config).to have_received(:question=).with("Which story do you want to branch-ify?")
        expect(config).to have_received(:options=).with([stories, :back])
        expect(config).to have_received(:columns=).with([:index, :story_type, :estimate, :name, :current_state])
        expect(question).to have_received(:ask)
      end
    end

    describe 'scope is backlog' do
      it 'should show the backlog stories' do
        project = instance_double('PGit::Project', id: 12345, api_token: 'someapitoken')
        options = { scope: :backlog }
        query = {scope: :backlog}
        story_1 = instance_double('PGit::Story',
                                  story_type: 'chore',
                                  estimate: 2,
                                  name: 'some story',
                                  current_state: 'unstarted')
        story_2 = instance_double('PGit::Story',
                                  story_type: 'feature',
                                  estimate: 3,
                                  name: 'some other story',
                                  current_state: 'unstarted')
        stories = [story_1, story_2]
        iteration_1 = double('PGit::Pivotal::Iteration', stories: stories)
        iterations = [iteration_1]
        iterations_obj = double('PGit::Pivotal::Iterations', get!: iterations)
        allow(PGit::Pivotal::Iterations).
          to receive(:new).with(query).and_return(iterations_obj)
        config = double('config', :question= => nil, :options= => nil, :columns= => nil)
        question = instance_double('Interactive::Question', ask: nil)
        response = instance_double('Interactive::Response', valid?: true)
        allow(question).to receive(:ask).and_yield(response)
        allow(Interactive::Question).to receive(:new).and_yield(config).and_return(question)
        handle_choose_story = instance_double('PGit::Bilateral::HandleChooseStory',
                                             execute!: nil)
        interactive_story = PGit::Bilateral::Story.new(options)
        response_options = {response: response, stories: stories, parent_question: interactive_story.question}
        allow(PGit::Bilateral::HandleChooseStory).to receive(:new).with(response_options).
          and_return(handle_choose_story)
        interactive_story.execute!

        expect(config).to have_received(:question=).with("Which story do you want to branch-ify?")
        expect(config).to have_received(:options=).with([stories, :back])
        expect(config).to have_received(:columns=).with([:index, :story_type, :estimate, :name, :current_state])
        expect(question).to have_received(:ask)
        expect(handle_choose_story).to have_received(:execute!)
      end
    end

    describe 'scope is current' do
      it 'should show a list of stories for the current iteration' do
        project = instance_double('PGit::Project', id: 12345, api_token: 'someapitoken')
        options = { scope: :current }
        query = {scope: :current}
        story_1 = instance_double('PGit::Story',
                                  story_type: 'chore',
                                  estimate: 2,
                                  name: 'some story',
                                  current_state: 'unstarted')
        story_2 = instance_double('PGit::Story',
                                  story_type: 'feature',
                                  estimate: 3,
                                  name: 'some other story',
                                  current_state: 'unstarted')
        stories = [story_1, story_2]
        iteration_1 = double('PGit::Pivotal::Iteration', stories: stories)
        iterations = [iteration_1]
        iterations_obj = double('PGit::Pivotal::Iterations', get!: iterations)
        allow(PGit::Pivotal::Iterations).
          to receive(:new).with(query).and_return(iterations_obj)
        config = double('config', :question= => nil, :options= => nil, :columns= => nil)
        question = instance_double('Interactive::Question', ask: nil)
        allow(Interactive::Question).to receive(:new).and_yield(config).and_return(question)
        interactive_story = PGit::Bilateral::Story.new(options)
        interactive_story.execute!

        expect(config).to have_received(:question=).with("Which story do you want to branch-ify?")
        expect(config).to have_received(:options=).with([stories, :back])
        expect(config).to have_received(:columns=).with([:index, :story_type, :estimate, :name, :current_state])
        expect(question).to have_received(:ask)
      end
    end

    describe 'scope is current_backlog' do
      it 'show a list of stories for the current and backlog iteration' do
        project = instance_double('PGit::Project', id: 12345, api_token: 'someapitoken')

        options = { scope: :current_backlog }
        query = {scope: :current_backlog}
        story_1 = instance_double('PGit::Story',
                                  story_type: 'chore',
                                  estimate: 2,
                                  name: 'some story',
                                  current_state: 'unstarted')
        story_2 = instance_double('PGit::Story',
                                  story_type: 'feature',
                                  estimate: 3,
                                  name: 'some other story',
                                  current_state: 'unstarted')
        stories = [story_1, story_2]
        iteration_1 = double('PGit::Pivotal::Iteration', stories: stories)
        iterations = [iteration_1]
        iterations_obj = double('PGit::Pivotal::Iterations', get!: iterations)
        allow(PGit::Pivotal::Iterations).
          to receive(:new).with(query).and_return(iterations_obj)
        config = double('config', :question= => nil, :options= => nil, :columns= => nil)
        question = instance_double('Interactive::Question', ask: nil)
        allow(Interactive::Question).to receive(:new).and_yield(config).and_return(question)
        interactive_story = PGit::Bilateral::Story.new(options)
        interactive_story.execute!

        expect(config).to have_received(:question=).with("Which story do you want to branch-ify?")
        expect(config).to have_received(:options=).with([stories, :back])
        expect(config).to have_received(:columns=).with([:index, :story_type, :estimate, :name, :current_state])
        expect(question).to have_received(:ask)
      end
    end
  end
end
