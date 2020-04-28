# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parameter_substitution/version"

Gem::Specification.new do |spec|
  spec.name         = "parameter_substitution"
  spec.version      = ParameterSubstitution::VERSION
  spec.authors      = ["Invoca Development"]
  spec.email        = ["development@invoca.com"]

  spec.summary     = 'Handles parsing an input strings with embedded substitution parameters and replacing them with values from a provided mapping.'
  spec.description = 'The substitution can be formatted using a syntax that looks like method calls'
  spec.homepage    = 'https://github.com/Invoca/parameter_substitution'
  spec.files       = Dir['lib/**/*.rb']

  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org'
  }
end
