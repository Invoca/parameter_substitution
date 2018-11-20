# frozen_string_literal: true

class ParameterSubstitution
  class Configuration
    attr_reader :custom_formatters

    def custom_formatters=(custom_formatters)
      check_for_find_method(custom_formatters)
      check_for_correct_base_class(custom_formatters)

      @custom_formatters = custom_formatters
    end

    private

    def check_for_find_method(custom_formatters)
      bad_formatters = reject_formatters_by_condition(custom_formatters) do |klass|
        klass.respond_to?(:find)
      end

      raise_for_bad_formatters_if_any(bad_formatters, "have a find method")
    end

    def check_for_correct_base_class(custom_formatters)
      bad_formatters = reject_formatters_by_condition(custom_formatters) do |klass|
        klass.ancestors.include?(ParameterSubstitution::Formatters::Base)
      end

      raise_for_bad_formatters_if_any(bad_formatters, "inherit from ParameterSubstitution::Formatters::Base and did not")
    end

    def reject_formatters_by_condition(custom_formatters)
      custom_formatters.reject do |_formatter, klass|
        yield(klass.constantize)
      end
    end

    def raise_for_bad_formatters_if_any(bad_formatters, failure_reason)
      if bad_formatters.any?
        log_context = bad_formatters.map { |formatter, klass| [formatter, klass].join(": ") }.join(", ")
        raise StandardError, "CONFIGURATION ERROR: custom_formatters (#{log_context}) must #{failure_reason}."
      end
    end
  end
end
