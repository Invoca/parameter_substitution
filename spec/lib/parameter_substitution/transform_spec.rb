# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/transform'

describe ParameterSubstitution::Transform do
  def parser
    ParameterSubstitution::Parser.new
  end

  def context(text, options = {})
    ParameterSubstitution::Context.new({ input: text, mapping: {} }.merge(options))
  end

  def transform(context)
    ParameterSubstitution::Transform.new(context)
  end

  def comparable_transformation(text)
    expression = transform(context(text)).apply(ParameterSubstitution::Parser.new.parse(text))
    expression.expression_list.map do |token|
      case token
      when ParameterSubstitution::TextExpression
        token.value
      when ParameterSubstitution::SubstitutionExpression
        "subst: #{token.parameter_name}#{token.method_calls.map { |f| " . #{f.name}(#{f.arguments.*.inspect.join(', ')})" }.join('')}"
      else
        raise "unexpected #{token}"
      end
    end
  end

  def string_arg_from_array(array)
    "(\"#{array.join('')}\")"
  end

  def transform_subexpression(rule, text)
    context        = context(text)
    sub_expression = parser.send(rule).parse(text)
    transform(context).apply(sub_expression)
  rescue Parslet::ParseFailed => error
    fail error.parse_failure_cause.ascii_tree
  end

  context "Transform" do
    context "#argument_list" do
      it "transform an argument list into an array of a single parameter" do
        expect(transform_subexpression(:argument_list, "(123)")).to eq([123])
        expect(transform_subexpression(:argument_list, "(\"abc\")")).to eq(['abc'])
      end

      it "transform an argument list into an array of parameters" do
        expect(transform_subexpression(:argument_list, "(123, 456)")).to eq([123, 456])
        expect(transform_subexpression(:argument_list, "(\"abc\", 456)")).to eq(["abc", 456])
        expect(transform_subexpression(:argument_list, "(nil, 1.5)")).to eq([nil, 1.5])
      end

      it "transform a string param with embeded slashes" do
        # Escaping slashes gets hard to read, so being verbose in favor of clarity.
        quote = '"'
        slash = "\\"

        expect(transform_subexpression(:argument_list, string_arg_from_array(['a', slash, quote, 'b', slash, quote, 'c'])))
          .to eq(['a"b"c'])

        expect(transform_subexpression(:argument_list, string_arg_from_array(['a', slash, slash, 'b'])))
          .to eq(['a\b'])

        expect(transform_subexpression(:argument_list, string_arg_from_array(['a', slash, slash, slash, slash, 'b'])))
          .to eq(["a#{slash}#{slash}b"])
      end

      it "transform an empty string argument" do
        expect(transform_subexpression(:argument_list, '("", 456)')).to eq(['', 456])
      end
    end

    context "full expressions" do
      it "generate an expression for a simple text" do
        expect(comparable_transformation("simple_text")).to eq(["simple_text"])
      end

      it "generate an expression for a substitution without method_calls" do
        expect(comparable_transformation("<parameter>")).to eq(["subst: parameter"])
      end

      it "generate an expression for a substitution with a method_call without args" do
        expect(comparable_transformation("<parameter.downcase>")).to eq(["subst: parameter . downcase()"])
      end

      it "generate an expression for a substitution with a method_call with arguments" do
        expect(comparable_transformation("<parameter.subst( 1 , 3)>")).to eq(["subst: parameter . subst(1, 3)"])
        expect(comparable_transformation("<parameter.subst( \"a\" , 3)>")).to eq(["subst: parameter . subst(\"a\", 3)"])
        expect(comparable_transformation("<parameter.left(12)>")).to eq(["subst: parameter . left(12)"])
      end

      it "generate an expression for a substitution with multiple method calls" do
        expect(comparable_transformation("<parameter.subst( \"a\" , 3).downcase.something(12)>"))
          .to eq(["subst: parameter . subst(\"a\", 3) . downcase() . something(12)"])
      end

      it "generate an expression for a substitution parameter with odd characters in it" do
        slash = "\\"

        expect(comparable_transformation("<with#{slash}>nonsense.downcase>"))
          .to eq(["subst: with>nonsense . downcase()"])
      end
    end
  end
end
