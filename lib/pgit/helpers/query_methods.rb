module PGit
  module Helpers
    module QueryMethods
      def set_attr(attribute)
        unless instance_variable_get("@#{attribute}")
          instance_variable_set("@#{attribute}", @query_hash[attribute.to_s] || yield)
        end
      end

      def not_given(attribute)
        "no_#{attribute}_given".to_sym
      end

      def ensure_given_queries
        given_attrs.each {|attr| ensure_given_attr(attr) }
      end

      def ensure_given_attr(attribute)
        attr = send(attribute)
        raise PGit::Error::User.new(attr.to_s) if attr == not_given(attribute)
      end

      def attr_query(*args)
        attr_has(args)
        attr_given(args)
      end

      def set_default_attr(attribute)
        set_attr(attribute) { not_given(attribute) }
      end

      def set_default_queries
        given_attrs.each {|attr| set_default_attr(attr) }
      end

      # attributes that have been set to default values
      def defaulted_attrs
        given_attrs.reject {|attr| send("given_#{attr}?")}
      end

      # attributes that have corresponding #given_attr? methods
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
            instance_variable_get("@#{item}") != not_given(item)
          end
        end
      end
    end
  end
end
