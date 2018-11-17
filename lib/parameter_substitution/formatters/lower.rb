# frozen_string_literal: true

class ParameterSubstitution::Formatters::Lower < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts to string and returns all characters lowercased, preserves nil."
  end

  def self.format(value)
    value&.to_s&.downcase
  end
end
