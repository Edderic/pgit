require 'pgit'

describe 'PGit::CurrentBranch' do
  describe '.name' do
    it 'should return the current branch' do
      git_branch_command = 'git branch'
      fake_current_branch = 'master'
      fake_branches = <<-FAKE_BRANCHES
        some-branch
        * master
        some-other-branch
      FAKE_BRANCHES

      allow(PGit::CurrentBranch).to receive(:`).with(git_branch_command).and_return(fake_branches)
      current_branch = PGit::CurrentBranch.name

      expect(current_branch).to eq fake_current_branch
    end
  end

  describe 'when there is error or fatal in the result' do
    it 'should raise the error' do
      git_branch_command = 'git branch'
      fake_current_branch = 'master'
      fake_branches = <<-FAKE_BRANCHES
        fatal: Not a git repository
          (or any of the parent directories): .git
      FAKE_BRANCHES

      allow(PGit::CurrentBranch).to receive(:`).with(git_branch_command).and_return(fake_branches)

      expect{PGit::CurrentBranch.name}.to raise_error(fake_branches)
    end
  end
end
