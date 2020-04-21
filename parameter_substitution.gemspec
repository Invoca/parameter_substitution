# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parameter_substitution/version"

Gem::Specification.new do |spec|
  spec.name         = "parameter_substitution"
  spec.version      = ParameterSubstitution::VERSION
  spec.authors      = ["Bob Smith", "James Ebentier"]
  spec.email        = ["bob@invoca.com", "jebentier@invoca.com", "cmcgrath@invoca.com"]

  spec.summary     = 'Handles parsing an input strings with embedded substitution parameters and replacing them with values from a provided mapping.'
  spec.description = 'The substitution can be formatted using a syntax that looks like method calls'
  spec.homepage    = 'https://github.com/Invoca/parameter_substitution'
  spec.files       = ['lib/parameter_substitution.rb']

  spec.metadata = {
    'allowed_push_host' => 'https://gem.fury.io/invoca'
  }
end
