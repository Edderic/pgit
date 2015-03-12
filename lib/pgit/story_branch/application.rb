module PGit
  class StoryBranch
    class Application
      def initialize(global_options, options, arguments)
        if story_id = options[:start]
          current_project = PGit::CurrentProject.new(PGit::Configuration.new)
          story = PGit::Pivotal::Story.new(current_project, story_id)
          story.get!
          name_parser = PGit::StoryBranch::NameParser.new(story)
          story_branch = PGit::StoryBranch.new(name_parser)

          story_branch.start
        else
          puts `pgit story_branch --help`
        end
      end
    end
  end
end
