# frozen_string_literal: true

class ParameterSubstitution::Formatters::SplitAfterColon < ParameterSubstitution::Formatters::Base
  def self.description
    "Returns the portion of a string after the first colon, or nil if there is no colon."
  end

  def self.format(value)
    value && value.to_s.split(':', 2)[1]&.lstrip
  end
end
