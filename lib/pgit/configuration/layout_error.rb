module PGit
  class Configuration
    class LayoutError < PGit::Error
      def prepend_general_message(message)
        "#{message}\nPlease have the following layout:\n" + YAML.dump(PGit::Configuration.default_options)
      end
    end
  end
end
