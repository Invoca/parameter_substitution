# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeStrftime < ParameterSubstitution::Formatters::DateTimeFormat
  def self.has_parameters?
    true
  end

  def self.description
    "Formats a DateTime with the provided format string."
  end

  def initialize(formatting_string)
    @formatting_string = formatting_string
  end

  def format(value)
    self.class.parse_to_time(value)&.strftime(@formatting_string).to_s
  end
end
