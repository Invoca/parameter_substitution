# frozen_string_literal: true

class ParameterSubstitution
  class Configuration
    attr_reader :method_call_base_class, :custom_formatters

    def method_call_base_class=(base_class)
      raise StandardError, "CONFIGURATION ERROR: base_class #{base_class} must have a find method" unless base_class.respond_to?(:find)

      @method_call_base_class = base_class
    end

    def custom_formatters=(custom_formatters)
      check_for_correct_base_class(custom_formatters)

      @custom_formatters = custom_formatters
    end

    private

    def check_for_correct_base_class(custom_formatters)
      bad_formatters = custom_formatters.reject do |_formatter, klass|
        klass.constantize.ancestors.include?(ParameterSubstitution::Formatters::Base)
      end

      if bad_formatters.any?
        log_context = bad_formatters.map { |formatter, klass| [formatter, klass].join(": ") }
        raise StandardError, "CONFIGURATION ERROR: custom_formatters (#{log_context}) must inherit from ParameterSubstitution::Formatters::Base and did not."
      end
    end
  end
end
