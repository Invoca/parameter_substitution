# frozen_string_literal: true

class ParameterSubstitution
  module Formatters
    class Manager
      class << self
        def find(key)
          all_formats[key.to_s]&.constantize
        end

        def all_formats
          default_formats.merge(custom_formatters_if_any)
        end

        def default_formats
          @default_formats ||= formatter_class_hash(__FILE__, ["ParameterSubstitution", "Formatters"])
        end

        def formatter_class_hash(manager_file, module_array)
          Hash[Dir[Pathname.new(manager_file).dirname + '*.rb'].map do |filename|
            class_key = File.basename(filename).chomp(".rb")
            class_name = (module_array + [class_key.camelize.to_s]).join('::')
            [class_key, class_name]
          end]
        end

        private

        def custom_formatters_if_any
          ParameterSubstitution.config&.custom_formatters || {}
        end
      end
    end
  end
end
