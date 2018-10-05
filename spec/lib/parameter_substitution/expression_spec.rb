# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/expression'

describe ParameterSubstitution::Expression do
  def context(text, options = {})
    context_args = {
      input:                text,
      mapping:              {
        "color"   => "red",
        "size"    => nil,
        "integer" => 1
      },
      destination_encoding: :cgi
    }.merge(options)
    ParameterSubstitution::Context.new(**context_args)
  end

  def parse_expression(parameter_expression, context_options = {})
    parser    = ParameterSubstitution::Parser.new
    transform = ParameterSubstitution::Transform.new(context(parameter_expression, context_options))
    transform.apply(parser.parse(parameter_expression))
  end

  context "ExpressionTest" do
    context "#validate" do
      it "report missing required parameters" do
        expression = parse_expression("simple_text", required_parameters: ["need_this"])
        expect { expression.validate }.to raise_exception(ParameterSubstitution::ParseError, "The following field must be included: 'need_this'")
      end

      it "report unknown parameters" do
        expression = parse_expression("<not_defined>")
        expect { expression.validate }.to raise_exception(ParameterSubstitution::ParseError, "Unknown replacement parameter 'not_defined'")
      end

      it "report errors from expressions" do
        expression = parse_expression("<color.undefined_method>")
        expect { expression.validate }.to raise_exception(ParameterSubstitution::ParseError, "Unknown method 'undefined_method'")
      end
    end

    context "evaluate" do
      it "handle direct substitution" do
        expect(".red.").to eq(parse_expression(".<color>.").evaluate)
      end

      it "report missing args as the string in angle brackets" do
        expect(".<not found>.").to eq(parse_expression(".<not found>.").evaluate)
      end

      it "handle raw output if there is a single parameter" do
        expect(1).to eq(parse_expression("<integer>", destination_encoding: :raw).evaluate)
      end

      it "convert raw output if there is more than one parameter" do
        expect("red1").to eq(parse_expression("<color><integer>", destination_encoding: :raw).evaluate)
      end
    end
  end
end
