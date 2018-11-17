# frozen_string_literal: true

class ParameterSubstitution::Formatters::IfNil < ParameterSubstitution::Formatters::Base
  def self.description
    "Takes one new_value parameter. If the input is nil, the input is replaced with new_value."
  end

  def self.has_parameters?
    true
  end

  def initialize(new_value)
    @new_value = new_value
  end

  def format(value)
    value.nil? ? @new_value : value
  end
end
