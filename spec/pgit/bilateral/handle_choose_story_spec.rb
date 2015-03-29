require 'spec_helper'

describe PGit::Bilateral::HandleChooseStory do
  describe '#execute' do
    before { Rainbow.enabled = false }
    it 'should ask what the user would like to do with the story' do
      story = instance_double('PGit::Pivotal::Story', name: 'Bring me the passengers')
      stories = [story]
      response = double('Interactive::Response', whole_number_0?: true, whole_number?: true, to_i: 0)
      what_to_do_message = "What would you like to do with #{story.name}?"
      what_to_do_question = instance_double('Interactive::Question',
                                :question= => nil,
                                :options= => nil,
                                ask: nil
                                )
      allow(Interactive::Question).to receive(:new).and_yield(what_to_do_question).and_return(what_to_do_question)
      string_options = ["start it", "start it and branch out"]
      choose_story_handler = PGit::Bilateral::HandleChooseStory.new(response, stories)
      choose_story_handler.execute!

      expect(what_to_do_question).to have_received(:options=).with([string_options,:back])
      expect(what_to_do_question).to have_received(:question=).with(what_to_do_message)
      expect(what_to_do_question).to have_received(:ask)
    end
  end
end
