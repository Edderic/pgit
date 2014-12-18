require 'spec_helper'

describe 'PGit::Heredoc' do
  describe '.remove_front_spaces' do
    it 'should return the script, formatted nicely' do
      unprocessed = <<-HEREDOC
          function get_pgit_commands
          {
            if [ -z $2 ]; then
              COMPREPLY=(`pgit help -c`)
            else
              COMPREPLY=(`pgit help -c $2`)
            fi
          }
          complete -F get_pgit_commands pgit
      HEREDOC

      expected_script =
        "function get_pgit_commands\n" +
        "{\n" +
        "  if [ -z $2 ]; then\n" +
        "    COMPREPLY=(`pgit help -c`)\n" +
        "  else\n" +
        "    COMPREPLY=(`pgit help -c $2`)\n" +
        "  fi\n" +
        "}\n" +
        "complete -F get_pgit_commands pgit\n"
      script = PGit::Heredoc.remove_front_spaces(unprocessed)

      expect(script).to eq expected_script
    end
  end
end
