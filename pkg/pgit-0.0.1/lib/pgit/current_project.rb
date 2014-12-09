#
#   Decides what the "current project" is, in relation to the pwd.
#
# - config_yaml: has the project configurations. It has at least one
#   project. Each project has an (pivotal) api_token, path, and (pivotal)
#   id
#

module PGit
  class CurrentProject
    def initialize(config_yaml)
      @current_project = find_current_project(config_yaml)
    end

    def pwd
      project_path = @current_project["path"]
      File.expand_path(project_path, __FILE__)
    end

    def id
      @current_project["id"]
    end

    def api_token
      @current_project["api_token"]
    end

    private

    def validate_pwd_match_at_least_one(matching_projects)
      if matching_projects.length == 0
        raise "None of the project paths matches the working directory"
      end
    end

    def escape_slashes(project_path)
      project_path.gsub('/','\/')
    end

    def find_matching_projects(projects)
      projects.select do |project|
        project_path = project["path"]
        extended_path = File.expand_path(project_path, __FILE__)
        escaped_project = escape_slashes(extended_path)
        Dir.pwd.match(/#{escaped_project}/)
      end
    end

    def find_current_project(config_yaml)
      projects = config_yaml["projects"]
      matching_projects = find_matching_projects(projects)

      validate_pwd_match_at_least_one(matching_projects)
      find_best_match(matching_projects)
    end

    def find_best_match(matching_projects)
      matching_projects.sort! { |a,b| b["path"].length <=> a["path"].length }
      matching_projects.first
    end
  end
end