# frozen_string_literal: true

class ParameterSubstitution::Formatters::Upper < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts to string and returns all characters uppercased, preserves nil."
  end

  def self.format(value)
    value&.to_s&.upcase
  end
end
