module PGit
  class Project
    attr_reader :path, :api_token
    [:path, :api_token].each do |method_name|
      define_method "has_#{method_name}?=" do |val|
        instance_variable_get(method_name) == val
      end
    end

    def initialize(project_hash)
      @path = project_hash.fetch('path')
      @api_token = project_hash.fetch('api_token')
    end



    # def has_path?(some_path)
      # path == some_path
    # end
#
    # def has_api_token?(some_api_token)
      # api_token == some_api_token
    # end
  end
end
