# frozen_string_literal: true

class ParameterSubstitution
  class MethodCallExpression
    attr_reader :name, :arguments

    def initialize(name, arguments)
      @name = name
      @arguments = arguments || []
    end

    def validate
      if format_class
        expected_arguments = format_class&.has_parameters? ? format_class.instance_method(:initialize).arity : 0
        if @arguments.size != expected_arguments
          raise ParameterSubstitution::ParseError, "Wrong number of arguments for '#{@name}' expected #{expected_arguments}, received #{@arguments.size}"
        end
      else
        raise ParameterSubstitution::ParseError, "Unknown method '#{@name}'"
      end
    end

    def call_method(value)
      column_formatter.format(value)
    end

    def encoding
      format_class.encoding
    end

    private

    def column_formatter
      @column_formatter ||= begin
        if format_class&.has_parameters?
          format_class.new(*format_args)
        else
          format_class
        end
      end
    end

    def format_class
      @format_class ||= ParameterSubstitution::Formatters::Manager.find(@name)
    end

    def format_args
      @arguments.map do |arg|
        case arg
        when ParameterSubstitution::Expression
          arg.evaluate
        else
          arg
        end
      end
    end
  end
end
