# frozen_string_literal: true

require 'json'
require_relative 'test_formatter_base'

class JsonParse < TestFormatterBase
  def self.description
    "attempts to parse strings as JSON. If valid, passes along the parsed object, if not valid json, or not a string, passes the json encoded value."
  end

  def self.has_parameters?
    false
  end

  def self.encoding
    :json
  end

  def self.format(value)
    if value.is_a?(String)
      JSON.parse(value)
      value
    else
      value.to_json
    end
  rescue JSON::ParserError
    value.to_json
  end
end
