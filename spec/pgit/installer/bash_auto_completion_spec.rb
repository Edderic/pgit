require 'spec_helper'

describe 'PGit::Installer::BashAutoCompletion' do
  describe 'FILENAME' do
    it 'should be ~/.pgit_auto_completion' do
      expect(PGit::Installer::BashAutoCompletion::FILENAME).to eq "~/.pgit_auto_completion"
    end
  end

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

      expected_script = PGit::Helpers::Heredoc.remove_front_spaces(unprocessed)
      script = PGit::Installer::BashAutoCompletion.script

      expect(script).to eq expected_script
    end
  end

  describe '#write_completer_file' do
    it "should write the auto completion script to #{PGit::Installer::BashAutoCompletion::FILENAME}" do
      global_opts = {}
      global_opts = {}
      opts = {}
      args = {}
      fake_file = instance_double('File')
      allow(fake_file).to receive(:puts).with(PGit::Installer::BashAutoCompletion.script).and_return(fake_file)
      allow(fake_file).to receive(:close)
      short_path = PGit::Installer::BashAutoCompletion::FILENAME
      short_bashrc_path = "~/.bashrc"
      expanded_path = "/Users/Edderic/#{PGit::Installer::BashAutoCompletion::FILENAME}"
      expanded_bashrc_path = "/Users/Edderic/.bashrc"
      bashrc_lines = [
        "# some more ls aliases\n",
        "alias ll='ls -alF'\n",
        "alias la='ls -A'\n",
        "alias l='ls -CF'\n" ]
      message = "Wrote autocompletion script under #{PGit::Installer::BashAutoCompletion::FILENAME}"

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
    describe '~/.bashrc does have "source ~#{PGit::Installer::BashAutoCompletion::FILENAME}"' do
      it 'should NOT source it' do
        global_opts = {}
        opts = {}
        args = {}
        fake_file = instance_double('File')
        fake_bashrc_file = instance_double('File')
        allow(fake_bashrc_file).to receive(:puts).with("source #{PGit::Installer::BashAutoCompletion::FILENAME}").and_return(fake_file)
        allow(fake_bashrc_file).to receive(:close)
        short_bashrc_path = "~/.bashrc"
        expanded_bashrc_path = "/Users/Edderic/.bashrc"
        bashrc_lines = [
          "# some more ls aliases\n",
          "alias ll='ls -alF'\n",
          "alias la='ls -A'\n",
          "source #{PGit::Installer::BashAutoCompletion::FILENAME}",
          "alias l='ls -CF'\n" ]
        message = "Already sourcing #{PGit::Installer::BashAutoCompletion::FILENAME} in ~/.bashrc"

        allow(File).to receive(:expand_path).with(short_bashrc_path).and_return(expanded_bashrc_path)
        allow(File).to receive(:open).with(expanded_bashrc_path, 'a').and_return(fake_bashrc_file)
        allow(File).to receive(:readlines).with(expanded_bashrc_path).and_return(bashrc_lines)

        installer = PGit::Installer::BashAutoCompletion.new(global_opts, opts, args)
        allow(installer).to receive(:puts).with(message)

        installer.source_completer_from_bashrc

        expect(fake_bashrc_file).not_to have_received(:puts).with "source #{PGit::Installer::BashAutoCompletion::FILENAME}"
        expect(fake_bashrc_file).not_to have_received(:close)
        expect(installer).to have_received(:puts).with(message)
      end
    end

    describe '~/.bashrc does not have the "source ~#{PGit::Installer::BashAutoCompletion::FILENAME}"' do
      it 'should source ~#{PGit::Installer::BashAutoCompletion::FILENAME}' do
        global_opts = {}
        opts = {}
        args = {}
        fake_file = instance_double('File')
        fake_bashrc_file = instance_double('File')
        allow(fake_bashrc_file).to receive(:puts).with("source #{PGit::Installer::BashAutoCompletion::FILENAME}").and_return(fake_file)
        allow(fake_bashrc_file).to receive(:close)
        short_bashrc_path = "~/.bashrc"
        expanded_bashrc_path = "/Users/Edderic/.bashrc"
        bashrc_lines = [
          "# some more ls aliases\n",
          "alias ll='ls -alF'\n",
          "alias la='ls -A'\n",
          "alias l='ls -CF'\n" ]
        installation_message = "~/.bashrc will now source #{PGit::Installer::BashAutoCompletion::FILENAME}"

        allow(File).to receive(:expand_path).with(short_bashrc_path).and_return(expanded_bashrc_path)
        allow(File).to receive(:open).with(expanded_bashrc_path, 'a').and_return(fake_bashrc_file)
        allow(File).to receive(:readlines).with(expanded_bashrc_path).and_return(bashrc_lines)

        installer = PGit::Installer::BashAutoCompletion.new(global_opts, opts, args)
        allow(installer).to receive(:puts).with(installation_message)

        installer.source_completer_from_bashrc

        expect(fake_bashrc_file).to have_received(:puts).with "source #{PGit::Installer::BashAutoCompletion::FILENAME}"
        expect(fake_bashrc_file).to have_received(:close)
        expect(installer).to have_received(:puts).with(installation_message)
      end
    end
  end
end
