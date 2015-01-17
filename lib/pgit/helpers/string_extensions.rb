module PGit
  module Helpers
    module StringExtensions
      def letter?(letter)
        match(/^#{letter}$/i)
      end
    end
  end
end

String.class_eval do
  include PGit::Helpers::StringExtensions
end
