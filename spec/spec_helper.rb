# frozen_string_literal: true

require 'rspec'
require 'pry-byebug'
require 'simplecov'
require 'parameter_substitution'
require 'helpers/test_formatter_base'
require 'helpers/downcase'
require 'helpers/add_prefix'
require 'helpers/compare_string'
require 'helpers/if_nil'
require 'helpers/json_parse'

SimpleCov.start

ParameterSubstitution.configure do |config|
  config.method_call_base_class = TestFormatterBase
end
