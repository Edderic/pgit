require 'spec_helper'

describe PGit::Bilateral::HandleChooseStory do
  describe '#execute' do
    before { Rainbow.enabled = false }

    it 'should not ask if the response is not a whole number' do
      story = instance_double('PGit::Pivotal::Story', name: 'Bring me the passengers')
      stories = [story]
      response = double('Interactive::Response', whole_number_0?: false, whole_number?: false, to_i: 0)
      what_to_do_message = "What would you like to do with #{story.name}?"
      what_to_do_question = instance_double('Interactive::Question',
                                            :question= => nil,
                                            :options= => nil,
                                            ask: nil
                                           )
      allow(Interactive::Question).to receive(:new).and_yield(what_to_do_question).and_return(what_to_do_question)
      string_options = ["start it", "start it and branch out"]
      back_handler = instance_double('PGit::Bilateral::HandleBack', execute!: nil)
      parent_question = double('parent_question')
      options = {response: response, stories: stories, parent_question: parent_question}
      allow(PGit::Bilateral::HandleBack).to receive(:new).with(options).and_return(back_handler)
      choose_story_handler = PGit::Bilateral::HandleChooseStory.new(options)
      choose_story_handler.execute!

      expect(what_to_do_question).not_to have_received(:ask)
      expect(back_handler).not_to have_received(:execute!)
    end

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
      back_handler = instance_double('PGit::Bilateral::HandleBack', execute!: nil)
      parent_question = double('parent_question')
      what_to_do_response = instance_double('Interactive::Response')
      options = {response: what_to_do_response, stories: stories, parent_question: parent_question}
      allow(PGit::Bilateral::HandleBack).to receive(:new).with(options).and_return(back_handler)
      response_options = { response: response, stories: stories, parent_question: parent_question }
      allow(what_to_do_question).to receive(:ask).and_yield(what_to_do_response)
      choose_story_handler = PGit::Bilateral::HandleChooseStory.new(response_options)
      choose_story_handler.execute!

      expect(what_to_do_question).to have_received(:options=).with([string_options,:back])
      expect(what_to_do_question).to have_received(:question=).with(what_to_do_message)
      expect(what_to_do_question).to have_received(:ask)
      expect(back_handler).to have_received(:execute!)
    end
  end
end
