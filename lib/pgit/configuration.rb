#
#   Loads the Pivotal-Git configuration file
#
# - config_path is the path to the pivotal-git configuration file
#   This loads the file. Throws an error if a key (such as api_token, path, id)
#   is missing. Check #general_error_message for more info
#

module PGit
  class Configuration
    def self.default_options
      {
        'projects' => [
          {
            'api_token' => 'somepivotalatoken124',
            'id' => '12345',
            "path" => "~/some/path/to/a/pivotal-git/project"
          },
          {
            'api_token' => 'somepivotalatoken124',
            'id' => '23429070',
            "path" => "~/some/other/pivotal-git/project"
          }
        ]
      }
    end

    attr_reader :config_path, :expanded_path

    def initialize(config_path = '~/.pgit.rc.yml')
      @config_path = config_path
      @expanded_path = File.expand_path(config_path)
      @hash = YAML::load_file(File.expand_path(config_path))
      @projs = @hash.fetch("projects") { [] }
    end

    def projects=(new_projects)
      @projs = new_projects
    end

    def projects
      @projs.map {|proj| PGit::Project.new(self, proj) }
    end

    def to_hash
      { 'projects' => projects.map { |proj| proj.to_hash } }
    end

    def save!
      YAML.dump(to_hash, File.open(expanded_path, 'w'))
    end
  end
end
