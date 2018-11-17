# frozen_string_literal: true

class ParameterSubstitution::Formatters::AddPrefix < ParameterSubstitution::Formatters::Base
  def self.description
    "This takes a prefix as a constructor parameter and prepends it to the value. If the value is blank, nothing is shown."
  end

  def self.has_parameters?
    true
  end

  def initialize(prefix)
    @prefix = prefix
  end

  def format(value)
    value.presence && (@prefix + value.to_s)
  end
end
