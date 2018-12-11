# frozen_string_literal: true

class ParameterSubstitution::Formatters::Downcase < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts to string and downcases the values, preserves nil."
  end

  def self.format(value)
    value&.to_s&.downcase
  end
end
