require 'spec_helper'

describe 'PGit::Configuration::NotFoundError' do
  it 'should inherit from PGit::Error' do
    ancestors = PGit::Configuration::NotFoundError.ancestors

    expect(ancestors).to include (PGit::Error)
  end

  it 'should complain that the Configuration file does not exist' do
    not_found_error = PGit::Configuration::NotFoundError.new
    message = not_found_error.instance_eval{ @message }

    expect(message).to eq "Default configuration file does not exist. Please run `pgit install`"
  end
end
