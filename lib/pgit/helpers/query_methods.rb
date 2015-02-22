module PGit
  module Helpers
    module QueryMethods
      def set_attr(attribute)
        unless instance_variable_get("@#{attribute}")
          instance_variable_set("@#{attribute}", @proj_hash[attribute] || yield)
        end
      end

      def not_provided(attribute)
        "no_#{attribute}_provided".to_sym
      end

      def ensure_provided(attribute)
        attr = send(attribute)
        raise PGit::Error::User, attr if attr == not_provided(attribute)
      end


      def attr_has(*args)
        args.each do |method_name|
          define_method "has_#{method_name}?" do |val|
            instance_variable_get("@#{method_name}") == val
          end
        end
      end

      def attr_given(*args)
        args.each do |item|
          define_method "given_#{item}?" do
            instance_variable_get("@#{item}") != not_provided(item)
          end
        end
      end
    end
  end
end
