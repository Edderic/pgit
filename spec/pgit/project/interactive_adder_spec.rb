require 'spec_helper'
describe 'PGit::Project::InteractiveAdder.new(proj)' do
  describe 'api_token does not exist' do
    it 'asks what the api token associated for the project is' do
      question = "What's the Pivotal Tracker API token (See http://pivotaltracker.com/profile)?"
      proj = instance_double('PGit::Project', api_token: :no_api_token_provided,
                                              id: 12345)
      allow_any_instance_of(PGit::Project::InteractiveAdder).to receive(:puts).with(question)
      api_token = 'SOMEAPITOKEN'
      response = instance_double('String', chomp: api_token)
      allow(STDIN).to receive(:gets).and_return(response)
      allow(proj).to receive(:api_token=).with(api_token)
      adder = PGit::Project::InteractiveAdder.new(proj)
      adder.gather_missing_data

      expect(adder).to have_received(:puts).with(question)
      expect(proj).to have_received(:api_token=).with(api_token)
    end
  end

  describe 'id does not exist' do
    it 'asks what the id associated for the project is' do
      question = "What's the id of this project (i.e. https://www.pivotaltracker.com/n/projects/XXXX where XXXX is the id)?"
      proj = instance_double('PGit::Project', id: :no_id_provided,
                                              api_token: '12349798072thstueohoheu')
      allow_any_instance_of(PGit::Project::InteractiveAdder).to receive(:puts).with(question)
      id = 12345678
      response = instance_double('String', chomp: id)
      allow(STDIN).to receive(:gets).and_return(response)
      allow(proj).to receive(:id=).with(id)
      adder = PGit::Project::InteractiveAdder.new(proj)
      adder.gather_missing_data

      expect(adder).to have_received(:puts).with(question)
      expect(proj).to have_received(:id=).with(id)
    end

    describe 'user already has a project somewhere' do
      it 'offers user chance to just use the id that is already provided' do
        question = 'There is at least one project saved in the configuration file. Do you want to reuse a project id? [Y/n]'
        question1 = "Which one?\n  1. path: '/my/project1', id: 12345"
        project1 = instance_double('PGit::Project',
                                  path: '/my/project1',
                                  id: 12345)
        projects = [project1]
        configuration = instance_double('PGit::Configuration', projects: projects)
        project = instance_double('PGit::Project', id: :no_id_provided,
                                                   api_token: '12349798072thstueohoheu')
        allow(project).to receive(:configuration).and_return(configuration)
        adder = PGit::Project::InteractiveAdder.new(project)
        response = 'y'
        allow(STDIN).to receive(:gets).and_return('y', 'y')
        allow(adder).to receive(:puts)

        adder.gather_missing_data
        expect(adder).to have_received(:puts).with(question)
        expect(adder).to have_received(:puts).with(question1)
      end
    end
  end
end
