# frozen_string_literal: true

class ParameterSubstitution
  class Configuration
    attr_reader :method_call_base_class

    def method_call_base_class=(base_class)
      raise StandardError, "CONFIGURATION ERROR: base_class #{base_class} must have a find method" unless base_class.respond_to?(:find)
      @method_call_base_class = base_class
    end
  end
end
