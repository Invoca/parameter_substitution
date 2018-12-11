# frozen_string_literal: true

class ParameterSubstitution::Formatters::InTimezone < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "Converts a date time to the specified time zone."
  end

  def self.has_parameters?
    true
  end

  def initialize(destination_timezone)
    @destination_timezone = destination_timezone
  end

  def format(value)
    if (value_as_time = self.class.parse_to_time(value))
      value_as_time.in_time_zone(@destination_timezone).strftime('%Y-%m-%d %H:%M:%S')
    else
      value
    end
  end
end
