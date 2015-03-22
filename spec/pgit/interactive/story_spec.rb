require 'spec_helper'

describe PGit::Interactive::Story do
  describe '#execute!' do
    it 'show a list of stories for the current iteration' do
      pending
      project = instance_double('PGit::Project', id: 12345)
      app = instance_double('PGit::Project::Application', project: project)
      story = PGit::Interactive::Story.new(app)
      story.execute!


      stories =
      Interactive::Question.new do |which_question|
        which_question.question = "Which story are you interested in?"
        which_question.options = [stories]
      end
      expect(story).to
    end
  end
end
