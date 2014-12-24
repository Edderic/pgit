module PGit
  module StringExtensions
    def letter?(letter)
      match(/^#{letter}$/i)
    end
  end
end

String.class_eval do
  prepend PGit::StringExtensions
end
