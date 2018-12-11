# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeUsShortYear < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "MM/DD/YY hh:mm"
  end

  def self.format(value)
    parse_to_time(value)&.strftime("%m/%d/%y %H:%M").to_s
  end
end
