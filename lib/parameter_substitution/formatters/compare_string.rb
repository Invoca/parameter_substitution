# frozen_string_literal: true

class ParameterSubstitution::Formatters::CompareString < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "Compares the field to a string and returns results based on the comparison"
  end

  def self.has_parameters?
    true
  end

  def initialize(compare_value, true_value, false_value)
    @compare_value = compare_value
    @true_value = true_value
    @false_value = false_value
  end

  def format(value)
    value.to_s.casecmp(@compare_value) == 0 ? @true_value : @false_value
  end
end
