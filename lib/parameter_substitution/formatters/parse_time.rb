# frozen_string_literal: true

class ParameterSubstitution::Formatters::ParseTime < ParameterSubstitution::Formatters::DateTimeFormat
  def self.description
    "Takes format_string as a parameter and uses format_string to parse the input as a time. Does not change the input if the value is not a time."
    end

  def self.has_parameters?
    true
  end

  def initialize(format_string)
    @format_string = format_string
  end

  def format(value)
    value && Time.strptime(value.to_s, @format_string).strftime('%Y-%m-%d %H:%M:%S')
  rescue ArgumentError => ex
    # strptime raises argument error if either argument is wrong.
    ex.message =~ /invalid .*strptime format/ or raise
    value
  end
end
