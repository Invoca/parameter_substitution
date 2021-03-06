# frozen_string_literal: true

require 'parameter_substitution'

# All test formatters should inherit from this base class
class TestFormatterBase < ParameterSubstitution::Formatters::Base
  class << self
    def find(name)
      case name
      when 'test_class'
        TestClass
      end
    end
  end
end
