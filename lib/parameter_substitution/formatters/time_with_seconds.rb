# frozen_string_literal: true

class ParameterSubstitution::Formatters::TimeWithSeconds < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "hh:mm:ss"
  end

  def self.format(value)
    parse_to_time(value)&.strftime("%H:%M:%S").to_s
  end
end
