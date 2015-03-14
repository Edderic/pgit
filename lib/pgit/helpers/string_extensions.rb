module PGit
  module Helpers
    module StringExtensions
      def letter?(letter)
        match(/^#{letter}$/i)
      end

      def index?
        match(/^[1-9][0-9]*$/)
      end
    end
  end
end

String.class_eval do
  include PGit::Helpers::StringExtensions
end
