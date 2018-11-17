# frozen_string_literal: true

class ParameterSubstitution::Formatters::CgiUnescape < ParameterSubstitution::Formatters::Base
  def self.description
    "Url-decodes the string, preserves nil."
  end

  def self.format(value)
    value && CGI.unescape(value.to_s)
  end
end
