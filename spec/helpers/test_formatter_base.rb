# frozen_string_literal: true

# All formatters should inherit from this base class
class TestFormatterBase
  class << self
    def find(name)
      case name
      when 'downcase'
        Downcase
      when 'add_prefix'
        AddPrefix
      when 'compare_string'
        CompareString
      when 'if_nil'
        IfNil
      when 'json_parse'
        JsonParse
      end
    end

    def has_parameters?
      false
    end

    def encoding
      :raw
    end
  end
end

#
# Formatters
#

class Downcase < TestFormatterBase
  def self.description
    "Converts to string and downcases the values, preserves nil"
  end

  def self.format(value)
    value && value.to_s.downcase
  end
end

class AddPrefix < TestFormatterBase
  def self.description
    "This takes a prefix as a constructor parameter and prepends it to the row value. If the value is blank, nothing is shown."
  end

  def self.has_parameters?
    true
  end

  def initialize(prefix)
    @prefix = prefix
  end

  def format(value)
    value.presence && (@prefix + value.to_s)
  end
end

class CompareString < TestFormatterBase
  def self.description
    "Compares the field to a string and returns results based on the comparison"
  end

  def self.has_parameters?
    true
  end

  def initialize(compare_value, true_value, false_value)
    @compare_value = compare_value
    @true_value    = true_value
    @false_value   = false_value
  end

  def format(value)
    if value.to_s.casecmp(@compare_value) == 0
      @true_value
    else
      @false_value
    end
  end
end

class IfNil < TestFormatterBase
  def self.has_parameters?
    true
  end

  def self.description
    "Takes one new_value parameter.  If the input is nil the input is replaced with new_value"
  end

  def initialize(new_value)
    @new_value = new_value
  end

  def format(value)
    value.nil? ? @new_value : value
  end
end

require 'json'
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
