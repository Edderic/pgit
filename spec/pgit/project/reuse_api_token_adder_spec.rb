require 'spec_helper'

describe 'PGit::Project::ReuseApiTokenAdder' do
  describe '#execute' do
    describe 'there is already a project in the configuration file' do
      it 'asks the right questions and the responses can be queried properly' do
        api_token = 'someapitoken123'
        path = 'some/path'
        project_in_config = instance_double('PGit::Project',
                                            api_token: api_token,
                                            path: path)
        projects = [project_in_config]
        project = instance_double('PGit::Project')
        allow(project).to receive(:api_token=).with(api_token)

        question1 = instance_double('Interactive::Question', :question= => nil,
                                                             :options= => nil)
        question2 = instance_double('Interactive::Question', :question= => nil,
                                                             :options= => nil)
        reuse_response = double('response', yes?: true)
        which_response = double('response', whole_number?: true, to_i: 0)
        story_1 = double('OpenStruct', api_token: api_token, path: path)
        allow(OpenStruct).to receive(:new).with(api_token: api_token, path: path).and_return(story_1)
        allow(Interactive::Question).to receive(:new).and_yield(question1).and_yield(question2).and_return(question1, question2)
        allow(question1).to receive(:columns=).with [:index, :api_token, :path]
        allow(question2).to receive(:columns=).with [:index, :api_token, :path]
        allow(question1).to receive(:ask_and_wait_for_valid_response).and_yield(reuse_response)
        allow(question2).to receive(:ask_and_wait_for_valid_response).and_yield(which_response)

        adder = PGit::Project::ReuseApiTokenAdder.new(project, projects)
        adder.execute!

        expect(question1).to have_received(:question=).with "Do you want to reuse an api token?"
        expect(question1).to have_received(:options=).with [:yes, :no]
        expect(question2).to have_received(:question=).with "Which one?"
        expect(question2).to have_received(:options=).with [[story_1], :cancel]
        expect(question2).to have_received(:columns=).with [:index, :api_token, :path]
      end
    end
  end
end
