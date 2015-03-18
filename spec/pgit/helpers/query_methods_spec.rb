require 'spec_helper'

describe 'PGit::Helpers::QueryMethods' do
  describe '#defaulted_attrs' do
    it 'should ensure that the class has the given attributes' do
      class SomeFakeClass
        include PGit::Helpers::QueryMethods
        extend PGit::Helpers::QueryMethods

        attr_accessor :some_query, :some_other_query
        attr_query :some_query, :some_other_query

        def initialize
          @some_query = :no_some_query_given
        end
      end

      fake = SomeFakeClass.new
      fake.some_other_query = 'set to non default'

      expect(fake.defaulted_attrs).to include(:some_query.to_s)
    end
  end
end
