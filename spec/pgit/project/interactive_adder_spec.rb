require 'spec_helper'
require 'byebug'

describe 'PGit::Project::InteractiveAdder.new(proj)' do
  describe 'api_token does not exist' do
    it 'asks what the api token associated for the project is' do
      question = "What's the project api_token?"
      project = instance_double('PGit::Project', defaulted_attrs: [:api_token])

      allow_any_instance_of(PGit::Project::InteractiveAdder).to receive(:puts).with(question)
      api_token = 'SOMEAPITOKEN'
      response = instance_double('String', chomp: api_token)
      allow(STDIN).to receive(:gets).and_return(response)
      allow(project).to receive(:api_token=).with(api_token)
      adder = PGit::Project::InteractiveAdder.new(project)
      adder.execute!

      expect(adder).to have_received(:puts).with(question)
      expect(project).to have_received(:api_token=).with(api_token)
    end
  end

  describe 'id does not exist' do
    it 'asks what the id associated for the project is' do
      question = "What's the project id?"
      project = instance_double('PGit::Project', defaulted_attrs: [:id])
      allow(project).to receive(:id=)
      allow_any_instance_of(PGit::Project::InteractiveAdder).to receive(:puts).with(question)
      id = 'someid'
      response = instance_double('String', chomp: id)
      allow(STDIN).to receive(:gets).and_return(response)
      allow(project).to receive(:id=).with(id)
      adder = PGit::Project::InteractiveAdder.new(project)
      adder.execute!

      expect(adder).to have_received(:puts).with(question)
      expect(project).to have_received(:id=).with(id)
    end
  end
end
