module PGit
  module Heredoc
    def self.remove_front_spaces(string)
      space_lengths = string.split("\n").select do |s|
        s.match(/\S/)
      end.map {|s| s.scan(/^\s*/).first.length }

      min_length = space_lengths.inject(100) do |accum, value|
        accum > value ?  value : accum
      end

      string.gsub!(/^\s{#{min_length}}/, '')
    end
  end
end
