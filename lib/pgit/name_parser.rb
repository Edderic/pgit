#
#   Parses pivotal story titles and turns them into git branch names
# - story.name: title of the pivotal tracker story
#
# - story_id: id of the pivotal tracker story
#
# ex: Fly so high in the sky 12345 becomes fly-so-high-sky-12345
module PGit
  class StoryBranch
    class NameParser
      def initialize(story)
        @story = story
        @story_name = story.name
      end

      def story_id
        @story.id
      end

      def name
        remove_fluff_words
        remove_non_alphanumeric_characters
        downcase
        add_story_id
      end

      private

      def remove_non_alphanumeric_characters
        words = @story_name.split(' ')
        split_words = words.each { |word| word.gsub!(/\W/, '') }
        @story_name = split_words.select do |word|
          !word.empty?
        end.join('-')
      end

      def remove_fluff_words
        fluff_words = %w{the on of}
        fluff_words.each { |fluff_word| @story_name.gsub!(/\b#{fluff_word}\b/i, '') }
        remove_extraneous_white_spaces
      end

      def remove_extraneous_white_spaces
        @story_name.strip!
        @story_name.gsub!(/\s+/, ' ')
      end

      def downcase
        @story_name.downcase!
      end

      def add_story_id
        "#{@story_name}-#{story_id}"
      end
    end
  end
end
