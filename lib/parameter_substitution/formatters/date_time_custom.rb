# frozen_string_literal: true
require "parameter_substitution/formatters/date_time_format"

class ParameterSubstitution::Formatters::DateTimeCustom < ParameterSubstitution::Formatters::DateTimeFormat
  def self.has_parameters?
    true
  end

  def self.description
    "Formats a Date String with the provided formatting, converts it's time zone, and then converts it to the desired formatting string."
  end

  def initialize(from_formatting_string, to_formatting_string, from_time_zone, to_time_zone)
    @parse_options = { from_formatting: from_formatting_string, from_time_zone: from_time_zone }
    @to_formatting = to_formatting_string
    @to_time_zone  = to_time_zone
  end

  def format(value)
    self.class.parse_to_time(value, @parse_options)&.in_time_zone(@to_time_zone)&.strftime(@to_formatting).to_s # rubocop:disable Lint/SafeNavigationChain
  end
end
