# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeUsShortAmPm < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "MM/DD/YYYY hh:mm PM"
  end

  def self.format(value)
    parse_to_time(value)&.strftime('%-m/%-d/%y %l:%M %p').to_s
  end
end
