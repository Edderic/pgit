require 'spec_helper'

describe 'PGit::Project::Add' do
  describe 'when path is not given' do
    it 'defaults to the working directory' do
      global_opts, opts, args = {}, {}, []
      fake_path = double('fake_path')
      allow(Dir).to receive(:pwd).and_return(fake_path)

      add = PGit::Project::Add.new(global_opts, opts, args)
      expect(add.path).to eq fake_path
    end
  end
end
