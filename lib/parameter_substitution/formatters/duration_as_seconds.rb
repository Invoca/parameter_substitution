# frozen_string_literal: true

class ParameterSubstitution::Formatters::DurationAsSeconds < ParameterSubstitution::Formatters::Base
  def self.description
    "Converts a duration to an integer value of seconds"
  end

  def self.format(value)
    parse_duration(value)
  end
end
