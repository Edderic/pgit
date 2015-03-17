require 'spec_helper'

describe 'PGit::Project::ReuseApiTokenAdder' do
  describe '#execute' do
    describe 'there is already a project in the configuration file' do
      it 'asks if you want to reuse an api token and uses that api_token if so' do
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
        allow(Interactive::Question).to receive(:new).and_return(question1, question2)
        allow(question1).to receive(:ask_and_wait_for_valid_response).and_yield(reuse_response)
        allow(question2).to receive(:ask_and_wait_for_valid_response).and_yield(which_response)

        adder = PGit::Project::ReuseApiTokenAdder.new(project, projects)
        adder.execute!

        expect(project).to have_received(:api_token=).with api_token
      end
    end
  end
end
