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
