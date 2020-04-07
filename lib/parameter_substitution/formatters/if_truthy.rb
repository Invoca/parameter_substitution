# frozen_string_literal: true

class ParameterSubstitution::Formatters::IfTruthy < ParameterSubstitution::Formatters::Base
  def self.description
    "The input is truthy (i.e. true, 1, y, YES) then the input is replaced with the first argument. Otherwise, the input is replaced with the second argument."
  end

  def self.has_parameters?
    true
  end

  def initialize(value_if_true, value_if_false)
    @value_if_true = value_if_true
    @value_if_false = value_if_false
  end

  def format(value)
    if [true, "true", 1, "1", "y", "yes"].include?(downcase_if_string(value))
      @value_if_true
    else
      @value_if_false
    end
  end

  :private

  def downcase_if_string(value)
    if value.is_a?(String)
      value.downcase
    else
      value
    end
  end
end
