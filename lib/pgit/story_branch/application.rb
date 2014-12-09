module PGit
  class StoryBranch
    class Application
      def initialize(global_options, options, arguments)
        if story_id = options[:start]
          config_yaml = PGit::Configuration.new.to_yaml
          current_project = PGit::CurrentProject.new(config_yaml)
          story = PGit::Story.new(story_id, current_project)
          story_branch = PGit::StoryBranch.new(story)

          story_branch.start
        else
          puts `pgit story_branch --help`
        end
      end
    end
  end
end
