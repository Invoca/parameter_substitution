# frozen_string_literal: true

class ParameterSubstitution
  class TextExpression
    attr_accessor :value
    def initialize(value)
      @value = value
    end

    def evaluate(_inside_quotes, only_expression: false)
      @value
    end

    def validate(_inside_quotes); end

    def parameter_name
      nil
    end

    def unknown_parameters(_inside_quotes)
      nil
    end

    def ends_inside_quotes(started_inside_quotes:)
      state = started_inside_quotes ? :InsideString : :OutsideString

      @value.chars.each do |c|
        case state

        when :InsideString
          if c == '"'
            state = :OutsideString
          elsif c == '\\'
            state = :InsideStringGotBackslash
          end

        when :OutsideString
          if c == '"'
            state = :InsideString
          end

        when :InsideStringGotBackslash
          state = :InsideString
        else
          raise "unexpected #{state}"
        end
      end

      state != :OutsideString
    end
  end
end
