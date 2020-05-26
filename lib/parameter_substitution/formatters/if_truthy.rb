# frozen_string_literal: true

class ParameterSubstitution::Formatters::IfTruthy < ParameterSubstitution::Formatters::Base
  TRUTHY_VALUES = [true, "true", "t", 1, "1", "on", "yes"]

  def self.description
    "If the input is truthy (i.e. true, \"t\", 1, \"on\", \"yes\") then the input is replaced with the first argument. Otherwise, the input is replaced with the second argument."
  end

  def self.has_parameters?
    true
  end

  def initialize(value_if_true, value_if_false)
    @value_if_true = value_if_true
    @value_if_false = value_if_false
  end

  def format(value)
    if TRUTHY_VALUES.include?(downcase_if_string(value))
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
