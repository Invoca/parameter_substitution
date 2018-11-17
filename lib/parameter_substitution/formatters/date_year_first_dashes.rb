# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateYearFirstDashes < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "YYYY-MM-DD"
  end

  def self.format(value)
    parse_to_time(value)&.strftime("%Y-%m-%d").to_s
  end
end
