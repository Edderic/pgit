require 'pgit'

describe 'PGit::CurrentBranch' do
  describe '#name' do
    it 'should return the current branch' do
      git_branch_command = 'git branch'
      fake_current_branch = 'master'
      fake_branches = <<-FAKE_BRANCHES
        some-branch
        * master
        some-other-branch
      FAKE_BRANCHES

      allow(PGit::CurrentBranch).to receive(:`).with(git_branch_command).and_return(fake_branches)
      current_branch_name = PGit::CurrentBranch.new.name

      expect(current_branch_name).to eq fake_current_branch
    end
  end

  describe '#story_id' do
    describe 'current branch has no story id' do
      it 'should return nil' do
        git_branch_command = 'git branch'
        fake_current_branch = 'master'
        fake_branches = <<-FAKE_BRANCHES
        some-branch
        * master
        some-other-branch
        FAKE_BRANCHES

        allow_any_instance_of(PGit::CurrentBranch).to receive(:`).with(git_branch_command).and_return(fake_branches)
        current_branch_story_id = PGit::CurrentBranch.new.story_id

        expect(current_branch_story_id).to be_nil
      end
    end

    describe 'current branch has story id' do
      it 'should return the story id' do
        git_branch_command = 'git branch'
        fake_current_branch = 'master'
        fake_branches = <<-FAKE_BRANCHES
        some-branch
        * some-feature-branch-123456
        some-other-branch
        FAKE_BRANCHES

        allow_any_instance_of(PGit::CurrentBranch).to receive(:`).with(git_branch_command).and_return(fake_branches)
        current_branch_story_id = PGit::CurrentBranch.new.story_id

        expect(current_branch_story_id).to eq '123456'
      end
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


      allow_any_instance_of(PGit::CurrentBranch).to receive(:`).with(git_branch_command).and_return(fake_branches)

      expect{PGit::CurrentBranch.new}.to raise_error(fake_branches)
    end
  end
end
