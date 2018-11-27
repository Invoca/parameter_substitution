# frozen_string_literal: true

class ParameterSubstitution
  class Configuration
    attr_reader :custom_formatters

    def custom_formatters=(custom_formatters)
      check_that_classes_are_classes(custom_formatters)
      check_for_correct_base_class(custom_formatters)

      @custom_formatters = custom_formatters
    end

    private

    def check_that_classes_are_classes(custom_formatters)
      bad_formatters = custom_formatters.reject do |_formatter, klass|
        klass.is_a?(Class)
      end

      raise_if_any(bad_formatters, "must be of type Class")
    end

    def check_for_correct_base_class(custom_formatters)
      bad_formatters = custom_formatters.reject do |_formatter, klass|
        klass.ancestors.include?(ParameterSubstitution::Formatters::Base)
      end

      raise_if_any(bad_formatters, "must inherit from ParameterSubstitution::Formatters::Base and did not")
    end

    def raise_if_any(formatters, failure_context)
      if formatters.any?
        log_context = formatters.map { |formatter, klass| [formatter, klass].join(": ") }.join(", ")
        raise StandardError, "CONFIGURATION ERROR: custom_formatters (#{log_context}) #{failure_context}."
      end
    end
  end
end
