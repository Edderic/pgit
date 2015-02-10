require 'spec_helper'
describe 'PGit::Project::InteractiveAdder.new(proj)' do
  describe 'api_token does not exist' do
    it 'asks what the api token associated for the project is' do
      question = "What's the Pivotal Tracker API token? (See 'Profile' section at http://pivotaltracker.com)"
      proj = instance_double('PGit::Project', api_token: :no_api_token_provided,
                                              id: 12345)
      allow_any_instance_of(PGit::Project::InteractiveAdder).to receive(:puts).with(question)
      api_token = 'SOMEAPITOKEN'
      response = instance_double('String', chomp: api_token)
      allow(STDIN).to receive(:gets).and_return(response)
      allow(proj).to receive(:api_token=).with(api_token)
      adder = PGit::Project::InteractiveAdder.new(proj)

      expect(adder).to have_received(:puts).with(question)
      expect(proj).to have_received(:api_token=).with(api_token)
    end
  end

  describe 'id does not exist' do
    it 'asks what the id associated for the project is' do
      question = "What's the id of this project (i.e. https://www.pivotaltracker.com/n/projects/XXXX wher XXXX is the id)?"
      proj = instance_double('PGit::Project', id: :no_id_provided,
                                              api_token: '12349798072thstueohoheu')
      allow_any_instance_of(PGit::Project::InteractiveAdder).to receive(:puts).with(question)
      id = 12345678
      response = instance_double('String', chomp: id)
      allow(STDIN).to receive(:gets).and_return(response)
      allow(proj).to receive(:id=).with(id)
      adder = PGit::Project::InteractiveAdder.new(proj)

      expect(adder).to have_received(:puts).with(question)
      expect(proj).to have_received(:id=).with(id)
    end
  end
end