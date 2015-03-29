require 'spec_helper'

describe PGit::Bilateral::HandleBack do
  describe '#execute!' do
    it 'should call #reask on the parent_question' do
      stories = double('stories')
      question = instance_double('Interactive::Question', reask!: nil)
      response = instance_double('Interactive::Response', back?: true)
      options = {response: response, parent_question: question, stories: stories}

      back_handler = PGit::Bilateral::HandleBack.new(options)
      back_handler.execute!

      expect(question).to have_received(:reask!)
    end

    it 'should not call #reask on the parent question if response is not back' do
      stories = double('stories')
      question = instance_double('Interactive::Question', reask!: nil)
      response = instance_double('Interactive::Response', back?: false)
      options = {response: response, parent_question: question, stories: stories}

      back_handler = PGit::Bilateral::HandleBack.new(options)
      back_handler.execute!

      expect(question).not_to have_received(:reask!)
    end
  end
end
