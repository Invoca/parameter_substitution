# frozen_string_literal: true

class ParameterSubstitution::Formatters::DollarsToCents < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts a dollar amount to cents as an integer"
  end

  def self.format(value)
    (Float(value) * 100).round.to_i rescue nil
  end
end
