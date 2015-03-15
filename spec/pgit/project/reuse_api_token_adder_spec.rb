require 'spec_helper'

describe 'PGit::Project::ReuseApiTokenAdder' do
  describe '#execute' do
    describe 'there is already a project in the configuration file' do
      it 'asks "Do you want to reuse an api token? [Y/n]"' do
        api_token = 'someapitoken123'
        path = 'some/path'
        project_in_config = instance_double('PGit::Project',
                                            api_token: api_token,
                                            path: path)
        projects = [project_in_config]
        project = instance_double('PGit::Project')
        allow(project).to receive(:api_token=).with(api_token)

        message = "Do you want to reuse an api token? [y/n]"
        adder = PGit::Project::ReuseApiTokenAdder.new(project, projects)
        yes_response = instance_double('String', chomp: 'y')
        cancel_response = instance_double('String', chomp: 'c')
        allow_any_instance_of(Interactive::Question).to receive(:puts)
        allow(adder).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return(yes_response, cancel_response)

        expect_any_instance_of(Interactive::Question).to receive(:puts).with(message)
        adder.execute!
      end

      describe 'user responds "y"' do
        it 'asks which one' do
          api_token = 'someapitoken123'
          path = '/some/path'
          project_in_config = instance_double('PGit::Project',
                                              api_token: api_token,
                                              path: path)
          projects = [project_in_config]
          project = instance_double('PGit::Project')

          message = "Do you want to reuse an api token? [Y/n]"
          which_one_message = "Which one? [1/c]"
          option_one_message = "  1.  #{path}: #{api_token}"

          adder = PGit::Project::ReuseApiTokenAdder.new(project, projects)
          response = instance_double('String', chomp: 'y')
          cancel_response = instance_double('String', chomp: 'c')
          allow(adder).to receive(:puts)
          allow(STDIN).to receive(:gets).and_return(response, cancel_response)

          adder.execute!
          expect(adder).to have_received(:puts).with(which_one_message)
          expect(adder).to have_received(:puts).with(option_one_message)
        end

        describe 'user responds "1"' do
          it 'sets the project api_token to the api_token corresponding to the index' do
            api_token = 'someapitoken123'
            path = '/some/path'
            project_in_config = instance_double('PGit::Project',
                                                api_token: api_token,
                                                path: path)
            projects = [project_in_config]
            project = instance_double('PGit::Project')
            allow(STDIN).to receive(:gets)
            project = instance_double('PGit::Project')

            message = "Do you want to reuse an api token? [Y/n]"
            which_one_message = "Which one? [1/c]"
            option_one_message = "  1.  #{path}: #{api_token}"

            adder = PGit::Project::ReuseApiTokenAdder.new(project, projects)
            yes_response = instance_double('String', chomp: 'y')
            cancel_response = instance_double('String', chomp: 'c')
            allow(adder).to receive(:puts)
            allow(STDIN).to receive(:gets).and_return(yes_response, cancel_response)
            allow(project).to receive(:api_token=).with(api_token)

            adder.execute!

            expect(project).not_to have_received(:api_token=)
          end
        end

        describe 'user responds with something else' do
          it 'should reprint the options' do
            api_token = 'someapitoken123'
            path = '/some/path'
            another_api_token = 'someotherapitoken'
            another_path = '/some/other/path'
            another_project_in_config = instance_double('PGit::Project',
                                                api_token: another_api_token,
                                                path: another_path)

            project_in_config = instance_double('PGit::Project',
                                                api_token: api_token,
                                                path: path)

            projects = [project_in_config, another_project_in_config]
            project = instance_double('PGit::Project')

            message = "Do you want to reuse an api token? [Y/n]"
            which_one_message = "Which one? [1/2/c]"
            option_one_message = "  1.  #{path}: #{api_token}"

            adder = PGit::Project::ReuseApiTokenAdder.new(project, projects)
            yes_response = instance_double('String', chomp: 'y')
            cancel_response = instance_double('String', chomp: 'c')
            unexpected_response = instance_double('String', chomp: 'a')

            allow(adder).to receive(:puts)
            allow(STDIN).to receive(:gets).and_return(yes_response, unexpected_response, cancel_response)
            allow(project).to receive(:api_token=).with(api_token)

            adder.execute!

            expect(adder).to have_received(:puts).with(which_one_message).twice
            expect(adder).to have_received(:puts).with(option_one_message).twice
          end
        end
      end
    end
  end
end
