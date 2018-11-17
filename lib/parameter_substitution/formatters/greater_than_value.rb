# frozen_string_literal: true

class ParameterSubstitution::Formatters::GreaterThanValue < ParameterSubstitution::Formatters::Base
  def self.description
    "Compares numerical values and returns results based on the comparison"
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
    self.class.parse_duration(value) > @compare_value.to_i ? @true_value : @false_value
  end
end
