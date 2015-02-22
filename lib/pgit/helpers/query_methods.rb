module PGit
  module Helpers
    module QueryMethods
      def set_attr(attribute)
        unless instance_variable_get("@#{attribute}")
          instance_variable_set("@#{attribute}", @proj_hash[attribute.to_s] || yield)
        end
      end

      def not_provided(attribute)
        "no_#{attribute}_provided".to_sym
      end

      def ensure_provided_queries
        given_attrs.each {|attr| ensure_provided_attr(attr) }
      end

      def ensure_provided_attrs(*attributes)
        attributes.each { |attr| ensure_provided_attr(attr) }
      end

      def ensure_provided_attr(attribute)
        attr = send(attribute)
        raise PGit::Error::User, attr if attr == not_provided(attribute)
      end

      def attr_query(*args)
        attr_has(args)
        attr_given(args)
      end

      def set_default_attr(attribute)
        set_attr(attribute) { not_provided(attribute) }
      end

      def set_default_attrs(*attributes)
        attributes.each { |attr| set_default_attr(attr) }
      end

      def set_default_queries
        given_attrs.each {|attr| set_default_attr(attr) }
      end

      def given_attrs
        methods.grep(/^given_.+\?$/).map { |m| m.to_s.gsub(/^given_/, '').gsub(/\?$/, '')}
      end

      def attr_has(args)
        args.each do |method_name|
          define_method "has_#{method_name}?" do |val|
            instance_variable_get("@#{method_name}") == val
          end
        end
      end

      def attr_given(args)
        args.each do |item|
          define_method "given_#{item}?" do
            instance_variable_get("@#{item}") != not_provided(item)
          end
        end
      end
    end
  end
end
