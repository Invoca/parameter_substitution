# frozen_string_literal: true

class ParameterSubstitution
  module Formatters
    class Base
      class << self
        def description
          raise NotImplementedError, "Derived classes must implement"
        end

        def format(_value)
          raise NotImplementedError, "Derived classes must implement"
        end

        def key
          name.split('::').last.gsub(/Format/, '').underscore
        end

        # Formats that have parameters are constructed and format is called on the instance.
        # Formats without parameters have format called on the class.
        def has_parameters?
          false
        end

        def encoding
          :raw
        end

        # TODO: Move out of the base class.
        def parse_duration(duration)
          if duration.is_a?(String)
            if duration =~ /([\d]{1,2})\:([\d]{1,2})\:([\d]{1,2})/
              (Regexp.last_match(1).to_i.hours + Regexp.last_match(2).to_i.minutes + Regexp.last_match(3).to_i.seconds).to_i
            elsif duration =~ /([\d]{1,2})\:([\d]{1,2})/
              (Regexp.last_match(1).to_i.minutes + Regexp.last_match(2).to_i.seconds).to_i
            else
              duration.to_i
            end
          else
            duration.to_i
          end
        end
      end
    end
  end
end
