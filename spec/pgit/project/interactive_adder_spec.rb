require 'spec_helper'
require 'byebug'

describe 'PGit::Project::InteractiveAdder.new(proj)' do
  describe 'api_token does not exist' do
    it 'asks what the api token associated for the project is' do
      question = "What's the project api_token?"
      api_token = 'SOMEAPITOKEN'
      id_1 = 123
      id_2 = 127
      project = instance_double('PGit::Project',
                                defaulted_attrs: [:api_token],
                               :id= => true)

      def project.api_token
        @api_token
      end

      def project.api_token=(some_api_token)
        @api_token = some_api_token
      end

      project.api_token = :no_api_token_given

      allow_any_instance_of(PGit::Project::InteractiveAdder).to receive(:puts).with(question)
      response = instance_double('String', chomp: api_token)
      allow(STDIN).to receive(:gets).and_return(response, '0')
      pivotal_project_1 = double('PGit::Pivotal::Project', name: 'Some Project Name 1',
                                id: id_1)
      pivotal_project_2 = double('PGit::Pivotal::Project', name: 'Some Project Name 2',
                                id: id_2)
      instantiated_projects = [pivotal_project_1, pivotal_project_2]
      projects = double('PGit::Pivotal::Projects')
      allow(projects).to receive(:get!).and_return(instantiated_projects)
      allow(PGit::Pivotal::Projects).to receive(:new).with(api_token: api_token).
        and_return(projects)
      adder = PGit::Project::InteractiveAdder.new(project)
      adder.execute!

      expect(adder).to have_received(:puts).with(question)
      expect(project.api_token).to eq api_token
      expect(project).to have_received(:id=).with(id_1)
    end
  end
end
