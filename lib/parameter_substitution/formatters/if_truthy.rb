# frozen_string_literal: true
require 'active_record'

class ParameterSubstitution::Formatters::IfTruthy < ParameterSubstitution::Formatters::Base
  def self.description
    "The input is truthy (i.e. true, t, 1) then the input is replaced with the first argument. Otherwise, the input is replaced with the second argument."
  end

  def self.has_parameters?
    true
  end

  def initialize(value_if_true, value_if_false)
    @value_if_true = value_if_true
    @value_if_false = value_if_false
  end

  def format(value)
    if ActiveRecord::Type::Boolean.new.type_cast_from_database(value)
      @value_if_true
    else
      @value_if_false
    end
  end
end
