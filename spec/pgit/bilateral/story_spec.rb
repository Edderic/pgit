require 'spec_helper'

describe PGit::Bilateral::Story do
  describe '#execute!' do
    it 'show a list of stories for the current iteration' do
      project = instance_double('PGit::Project', id: 12345, api_token: 'someapitoken')

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
      interactive_story = PGit::Bilateral::Story.new
      interactive_story.execute!

      expect(config).to have_received(:question=).with("Which story are you interested in?")
      expect(config).to have_received(:options=).with([stories, :back])
      expect(config).to have_received(:columns=).with([:index, :story_type, :estimate, :name, :current_state])
      expect(question).to have_received(:ask)
    end
  end
end
