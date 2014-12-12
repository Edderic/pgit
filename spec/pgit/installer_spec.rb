require 'pgit'

describe 'PGit::Installer' do
  describe '~/pgit.rc.yml exists' do
    it 'should raise an error' do
      global_opts = {}
      opts = { }
      args = {}
      message = "Error: ~/.pgit.rc.yml already exists"
      default_file_path = "~/.pgit.rc.yml"
      file_expanded_path = "/home/edderic/.pgit.rc.yml"

      allow(File).to receive(:expand_path).
        with(".")
      allow(File).to receive(:expand_path).
        with(default_file_path).and_return(file_expanded_path)
      allow(File).to receive(:exists?).
        with(file_expanded_path).and_return(true)

      expect do
        PGit::Installer.new(global_opts, opts, args)
      end.to raise_error message
    end
  end

  describe '~/pgit.rc.yml does not exist' do
    it 'should ask to continue or not' do
      global_opts = {}
      opts = { }
      args = {}

      message = "*** Installing example pgit configuration file under ~/.pgit.rc.yml. " +
        "Continue? [Y/n]"
      confirmation_message = "Saving example pgit config in ~/.pgit.rc.yml..."
      edit_message = "Saved! Please edit ~/.pgit.rc.yml and add the proper Pivotal Tracker API tokens, id, and file paths for each project"
      answer = instance_double("String", chomp: 'y')
      expanded_path = "/home/edderic/.pgit.rc.yml"
      fake_writable_file = double('File')
      allow(File).to receive(:expand_path).with("~/.pgit.rc.yml").and_return(expanded_path)
      allow(File).to receive(:exists?).with(expanded_path).and_return(false)
      allow(File).to receive(:open).with(expanded_path, 'w').and_return(fake_writable_file)
      allow(STDIN).to receive(:gets).and_return(answer)
      allow_any_instance_of(PGit::Installer).to receive(:puts).with(message)
      allow_any_instance_of(PGit::Installer).to receive(:puts).with(confirmation_message)
      allow_any_instance_of(PGit::Installer).to receive(:puts).with(edit_message)
      installer = PGit::Installer.new(global_opts, opts, args)

      expect(installer).to have_received(:puts).with(message)
    end

    describe 'user answers "y"' do
      it "should show the save message" do
        global_opts = {}
        opts = { }
        args = {}

        first_message = "*** Installing example pgit configuration file under ~/.pgit.rc.yml. " +
          "Continue? [Y/n]"
        save_message = "Saving example pgit config in ~/.pgit.rc.yml..."
        expanded_path = "/home/edderic/.pgit.rc.yml"
        edit_message = "Saved! Please edit ~/.pgit.rc.yml and add the proper Pivotal Tracker API tokens, id, and file paths for each project"
        fake_writable_file = double('File')
        allow(File).to receive(:expand_path).with("~/.pgit.rc.yml").and_return(expanded_path)
        allow(File).to receive(:exists?).with(expanded_path).and_return(false)
        allow(File).to receive(:open).with(expanded_path, 'w').and_return(fake_writable_file)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(edit_message)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(first_message)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(save_message)

        answer = instance_double("String", chomp: 'Y')
        allow(STDIN).to receive(:gets).and_return(answer)

        installer = PGit::Installer.new(global_opts, opts, args)

        expect(installer).to have_received(:puts).with(save_message)
      end

      it 'should save the file under ~/.pgit.rc.yml' do
        global_opts = {}
        opts = { }
        args = {}

        first_message = "*** Installing example pgit configuration file under ~/.pgit.rc.yml. " +
          "Continue? [Y/n]"
        save_message = "Saving example pgit config in ~/.pgit.rc.yml..."
        expanded_path = "/home/edderic/.pgit.rc.yml"
        fake_writable_file = double('File')
        edit_message = "Saved! Please edit ~/.pgit.rc.yml and add the proper Pivotal Tracker API tokens, id, and file paths for each project"
        allow(File).to receive(:expand_path).with("~/.pgit.rc.yml").and_return(expanded_path)
        allow(File).to receive(:exists?).with(expanded_path).and_return(false)
        allow(File).to receive(:open).with(expanded_path, 'w').and_return(fake_writable_file)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(first_message)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(save_message)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(edit_message)

        answer = instance_double("String", chomp: 'Y')
        allow(STDIN).to receive(:gets).and_return(answer)

        installer = PGit::Installer.new(global_opts, opts, args)

        expect(File).to have_received(:open).with(expanded_path, 'w')
      end

      it 'should ask the user to edit the config file' do
        global_opts = {}
        opts = { }
        args = {}

        first_message = "*** Installing example pgit configuration file under ~/.pgit.rc.yml. " +
          "Continue? [Y/n]"
        save_message = "Saving example pgit config in ~/.pgit.rc.yml..."
        edit_message = "Saved! Please edit ~/.pgit.rc.yml and add the proper Pivotal Tracker API tokens, id, and file paths for each project"
        expanded_path = "/home/edderic/.pgit.rc.yml"
        fake_writable_file = double('File')
        allow(File).to receive(:expand_path).with("~/.pgit.rc.yml").and_return(expanded_path)
        allow(File).to receive(:exists?).with(expanded_path).and_return(false)
        allow(File).to receive(:open).with(expanded_path, 'w').and_return(fake_writable_file)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(first_message)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(edit_message)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(save_message)

        answer = instance_double("String", chomp: 'Y')
        allow(STDIN).to receive(:gets).and_return(answer)

        installer = PGit::Installer.new(global_opts, opts, args)

        expect(installer).to have_received(:puts).with(edit_message)
      end
    end

    describe 'user answers with "n"' do
      it "should show the abort message" do
        message = "Aborting installation..."
        global_opts = {}
        opts = { }
        args = {}

        first_message = "*** Installing example pgit configuration file under ~/.pgit.rc.yml. " +
          "Continue? [Y/n]"
        expanded_path = "/home/edderic/.pgit.rc.yml"
        allow(File).to receive(:expand_path).with("~/.pgit.rc.yml").and_return(expanded_path)
        allow(File).to receive(:exists?).with(expanded_path).and_return(false)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(first_message)
        allow_any_instance_of(PGit::Installer).to receive(:puts).with(message)

        answer = instance_double("String", chomp: 'n')
        allow(STDIN).to receive(:gets).and_return(answer)

        installer = PGit::Installer.new(global_opts, opts, args)

        expect(installer).to have_received(:puts).with(message)
      end
    end

    describe 'user answers with something els' do
    end
  end
end
