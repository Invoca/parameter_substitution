# require_relative '../helpers/downcase'

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
      end
    end

    def has_parameters?
      false
    end
  end
end

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
