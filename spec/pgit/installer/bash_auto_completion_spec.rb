require 'spec_helper'

describe 'PGit::Installer::BashAutoCompletion' do
  describe '.script' do
    it 'should return the script, formatted nicely' do
      unprocessed = <<-UNPROCESSED
        function get_pgit_commands
        {
          if [ -z $2 ]; then
            COMPREPLY=(`pgit help -c`)
          else
            COMPREPLY=(`pgit help -c $2`)
          fi
        }
        complete -F get_pgit_commands pgit
      UNPROCESSED

      expected_script = PGit::Heredoc.remove_front_spaces(unprocessed)
      script = PGit::Installer::BashAutoCompletion.script

      expect(script).to eq expected_script
    end
  end

  describe '#write_completer_file' do
    it 'should write the auto completion script to ~/.pgit_autocompletion' do
      global_opts = {}
      global_opts = {}
      opts = {}
      args = {}
      fake_file = instance_double('File')
      allow(fake_file).to receive(:puts).with(PGit::Installer::BashAutoCompletion.script).and_return(fake_file)
      allow(fake_file).to receive(:close)
      short_path = "~/.pgit_auto_completion"
      short_bashrc_path = "~/.bashrc"
      expanded_path = "/Users/Edderic/.pgit_auto_completion"
      expanded_bashrc_path = "/Users/Edderic/.bashrc"
      bashrc_lines = [
        "# some more ls aliases\n",
        "alias ll='ls -alF'\n",
        "alias la='ls -A'\n",
        "alias l='ls -CF'\n" ]
      message = "Wrote autocompletion script under ~/.pgit_auto_completion"

      allow(File).to receive(:expand_path).with(short_path).and_return(expanded_path)
      allow(File).to receive(:open).with(expanded_path, 'w').and_return(fake_file)
      allow(File).to receive(:readlines).with(expanded_bashrc_path).and_return(bashrc_lines)

      installer = PGit::Installer::BashAutoCompletion.new(global_opts, opts, args)
      allow(installer).to receive(:puts).with(message)

      installer.write_completer_file

      expect(fake_file).to have_received(:puts).with(PGit::Installer::BashAutoCompletion.script)
      expect(fake_file).to have_received(:close)
      expect(installer).to have_received(:puts).with(message)
    end
  end

  describe '#source_completer_from_bashrc' do
    describe '~/.bashrc does have "source ~/.pgit_auto_completion"' do
      it 'should NOT source it' do
        global_opts = {}
        opts = {}
        args = {}
        fake_file = instance_double('File')
        fake_bashrc_file = instance_double('File')
        allow(fake_bashrc_file).to receive(:puts).with("source ~/.pgit_auto_completion").and_return(fake_file)
        allow(fake_bashrc_file).to receive(:close)
        short_bashrc_path = "~/.bashrc"
        expanded_bashrc_path = "/Users/Edderic/.bashrc"
        bashrc_lines = [
          "# some more ls aliases\n",
          "alias ll='ls -alF'\n",
          "alias la='ls -A'\n",
          "source ~/.pgit_auto_completion",
          "alias l='ls -CF'\n" ]
        message = "Already sourcing ~/.pgit_auto_completion in ~/.bashrc"

        allow(File).to receive(:expand_path).with(short_bashrc_path).and_return(expanded_bashrc_path)
        allow(File).to receive(:open).with(expanded_bashrc_path, 'a').and_return(fake_bashrc_file)
        allow(File).to receive(:readlines).with(expanded_bashrc_path).and_return(bashrc_lines)

        installer = PGit::Installer::BashAutoCompletion.new(global_opts, opts, args)
        allow(installer).to receive(:puts).with(message)

        installer.source_completer_from_bashrc

        expect(fake_bashrc_file).not_to have_received(:puts).with "source ~/.pgit_auto_completion"
        expect(fake_bashrc_file).not_to have_received(:close)
        expect(installer).to have_received(:puts).with(message)
      end
    end

    describe '~/.bashrc does not have the "source ~/.pgit_auto_completion"' do
      it 'should source ~/.pgit_auto_completion' do
        global_opts = {}
        opts = {}
        args = {}
        fake_file = instance_double('File')
        fake_bashrc_file = instance_double('File')
        allow(fake_bashrc_file).to receive(:puts).with("source ~/.pgit_auto_completion").and_return(fake_file)
        allow(fake_bashrc_file).to receive(:close)
        short_bashrc_path = "~/.bashrc"
        expanded_bashrc_path = "/Users/Edderic/.bashrc"
        bashrc_lines = [
          "# some more ls aliases\n",
          "alias ll='ls -alF'\n",
          "alias la='ls -A'\n",
          "alias l='ls -CF'\n" ]

        allow(File).to receive(:expand_path).with(short_bashrc_path).and_return(expanded_bashrc_path)
        allow(File).to receive(:open).with(expanded_bashrc_path, 'a').and_return(fake_bashrc_file)
        allow(File).to receive(:readlines).with(expanded_bashrc_path).and_return(bashrc_lines)

        bash_autocompletion_installer = PGit::Installer::BashAutoCompletion.new(global_opts, opts, args)

        bash_autocompletion_installer.source_completer_from_bashrc

        expect(fake_bashrc_file).to have_received(:puts).with "source ~/.pgit_auto_completion"
        expect(fake_bashrc_file).to have_received(:close)
      end
    end
  end
end
