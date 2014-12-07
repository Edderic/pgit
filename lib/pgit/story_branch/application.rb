module PGit
  class StoryBranch
    class Application
      def initialize(global_options, options, arguments)
        if start_id = options[:start]
          config = PGit::Configuration.new
          story_branch = PGit::StoryBranch.new(start_id, config.to_yaml)
          story_branch.start
        end
      end
    end
  end
end
