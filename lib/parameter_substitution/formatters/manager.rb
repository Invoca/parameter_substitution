# frozen_string_literal: true

class ParameterSubstitution
  module Formatters
    class Manager
      class << self
        def find(key)
          all_formats[key.to_s]&.constantize
        end

        def all_formats
          default_formatter_mapping.merge(ParameterSubstitution.config&.custom_formatters || {})
        end

        def default_formatter_mapping
          unless defined?(@default_formatter_mapping)
            @default_formatter_mapping = formatter_class_hash(__FILE__, ["ParameterSubstitution", "Formatters"])
          end
          @default_formatter_mapping
        end

        def formatter_class_hash(manager_file, module_array)
          Hash[Dir[Pathname.new(manager_file).dirname + '*.rb'].map do |filename|
            class_key = File.basename(filename).chomp(".rb")
            class_name = (module_array + [class_key.camelize.to_s]).join('::')
            [class_key, class_name]
          end]
        end
      end
    end
  end
end
