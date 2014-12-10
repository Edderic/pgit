#
#   Parses pivotal story titles and turns them into git branch names
# - unparsed_name: title of the pivotal tracker story
#
# - story_id: id of the pivotal tracker story
#
# ex: Fly so high in the sky 12345 becomes fly-so-high-sky-12345
module PGit
  class StoryBranch
    class NameParser
      def initialize(story)
        @story_id = story.id
        @unparsed_name = story.name
      end

      def parse
        remove_fluff_words
        remove_extraneous_white_spaces
        remove_periods
        replace_whitespace_with_dashes
        downcase
        add_story_id
      end

      private

      def remove_periods
        @unparsed_name.gsub!('.', '')
      end

      def remove_fluff_words
        fluff_words = %w{the on of}
        fluff_words.each { |fluff_word| @unparsed_name.gsub!(/\b#{fluff_word}\b/i, '') }
        remove_extraneous_white_spaces
      end

      def remove_extraneous_white_spaces
        @unparsed_name.strip!
        @unparsed_name.gsub!(/\s+/, ' ')
      end

      def replace_whitespace_with_dashes
        @unparsed_name.gsub!(' ', '-')
      end

      def downcase
        @unparsed_name.downcase!
      end

      def add_story_id
        "#{@unparsed_name}-#{@story_id}"
      end
    end
  end
end
