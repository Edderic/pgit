require 'spec_helper'

describe 'PGit::Pivotal::Request' do
  describe '#get!' do
    it 'does a cURL request' do
      class SomeSubclass < PGit::Pivotal::Request
        attr_reader :api_token
        def initialize
          @api_token
        end

        def sublink
          'some/link'
        end
      end

      json = double('JSON')
      some_subclass = SomeSubclass.new
      some_other_subclass = SomeSubclass.new

      api_token = some_subclass.api_token
      link = "https://www.pivotaltracker.com/services/v5/some/link"
      get_request = "curl -X GET -H 'X-TrackerToken: #{api_token}' #{link}"
      allow(JSON).to receive(:parse).with(json).and_return({ 'kind' => 'project', 'someattr' => '123'})
      allow(some_subclass).to receive(:`).with(get_request).and_return(json)

      some_subclass.get!

      expect(some_subclass).to have_received(:`).with(get_request)
      expect(some_subclass).to respond_to(:someattr)
      expect(some_other_subclass).not_to respond_to(:someattr)
    end
  end
end
