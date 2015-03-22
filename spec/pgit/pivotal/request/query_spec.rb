require 'spec_helper'

describe PGit::Pivotal::Request::Query do
  describe '#new(scope: :current_backlog)' do
    it 'should generate the right query string ' do
      query = PGit::Pivotal::Request::Query.new
      expect("#{query}").to eq ''
    end
  end

  describe '#new(scope: :current_backlog)' do
    it 'should generate the right query string ' do
      query = PGit::Pivotal::Request::Query.new(scope: :current_backlog)
      expect("#{query}").to eq '?scope=current_backlog'
    end
  end

  describe '#new(scope: :current_backlog, offset: 1)' do
    it 'should generate the right query string ' do
      query = PGit::Pivotal::Request::Query.new(scope: :current_backlog, offset: 1)
      expect("#{query}").to eq '?scope=current_backlog&offset=1'
    end
  end
end
