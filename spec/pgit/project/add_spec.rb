require 'spec_helper'

describe 'PGit::Project::Add' do
  describe 'user is on a project path that already exists' do
    it 'raises an error' do
      app = instance_double('PGit::Project::Application',
                            exists?: true)
      expect{PGit::Project::Add.new(app)}.to raise_error(PGit::Error::User, 'Project path already exists. See `pgit proj update --help.`')
    end
  end

  describe '#execute!' do
    it 'instantiates a project and saves it' do
      app = instance_double('PGit::Project::Application',
                            exists?: false)
      add = PGit::Project::Add.new(app)
      allow(app).to receive(:save!)
      allow(add).to receive(:puts).with("Successfully added the project!")
      add.execute!

      expect(app).to have_received(:save!)
      expect(add).to have_received(:puts).with("Successfully added the project!")
    end
  end
end
