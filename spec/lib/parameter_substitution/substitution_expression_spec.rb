# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/substitution_expression'

describe ParameterSubstitution::SubstitutionExpression do
  def context(text, options = {})
    context_args = {
      input: text,
      mapping: {
        "color" => "red",
        "size" => nil
      },
      destination_encoding: :cgi
    }.merge(options)
    ParameterSubstitution::Context.new(**context_args)
  end

  def parse_parameter(parameter_expression, context_options = {})
    parser    = ParameterSubstitution::Parser.new
    transform = ParameterSubstitution::Transform.new(context(parameter_expression, context_options))
    transform.apply(parser.parameter.parse(parameter_expression))
  end

  context "SubstitutionExpression" do
    it "take a list of formatters" do
      expression = parse_parameter("campaign")

      expect(expression.parameter_name).to eq('campaign')
      expect(expression.method_calls).to eq([])
      expect(expression.context.destination_encoding).to eq(:cgi)
    end

    it "try to match against method names if the parameter name was not found" do
      expression = parse_parameter("call.transaction_type", mapping: { "call.transaction_type" => "call" })
      expect(expression.parameter_name).to eq('call.transaction_type')
      expect(expression.method_calls).to eq([])

      expression = parse_parameter("call.transaction_type.downcase", mapping: { "call.transaction_type" => "call" })
      expect(expression.parameter_name).to eq('call.transaction_type')
      expect(expression.method_calls.*.name).to eq(['downcase'])
    end

    context "validate" do
      it "report nil parameters" do
        expression = parse_parameter("size")

        expect { expression.validate(false) }.to raise_exception(ParameterSubstitution::ParseError, "Replacement parameter 'size' is nil")
      end

      it "report errors from formats" do
        expression = parse_parameter("red.not_a_method")

        expect { expression.validate(false) }.to raise_exception(ParameterSubstitution::ParseError, "Unknown method 'not_a_method'")
      end
    end

    context "#evaluate" do
      it "perform the substitution when the value is available" do
        expression = parse_parameter("color")

        expect(expression.evaluate(true)).to eq('red')
        expect(expression.evaluate(false)).to eq('red')
      end

      it "put the parameter name in when the mapping is not available" do
        expression = parse_parameter("sound")

        expect(expression.evaluate(true)).to eq('<sound>')
        expect(expression.evaluate(false)).to eq('<sound>')
      end

      it "handle if nil" do
        expression = parse_parameter('size.if_nil("medium")', destination_encoding: :raw)

        expect(expression.evaluate(true)).to eq('medium')
        expect(expression.evaluate(false)).to eq('medium')
        expect(expression.evaluate(true, only_expression: true)).to eq('medium')
      end

      it "when destination encoding is raw, return missing parameters as empty strings if the only expression" do
        expression = parse_parameter("not_found", destination_encoding: :raw)

        expect(expression.evaluate(true, only_expression: true)).to eq('')
        expect(expression.evaluate(true, only_expression: false)).to eq('<not_found>')
      end

      it "when destination encoding is raw, return nil parameters as empty strings if the only expression" do
        expression = parse_parameter("size", destination_encoding: :raw)
        expect(expression.evaluate(true, only_expression: true)).to eq('')
        expect(expression.evaluate(true, only_expression: false)).to eq('<size>')
      end
    end

    context "#unknown_parameters" do
      it "report missing when not json in quotes" do
        expression = parse_parameter("not_found")

        expect(expression.unknown_parameters(true)).to eq('not_found')
        expect(expression.unknown_parameters(false)).to eq('not_found')
      end

      it "when json only report when not in quotes" do
        expression = parse_parameter("not_found", destination_encoding: :json)

        expect(expression.unknown_parameters(false)).to eq('not_found')
        expect(expression.unknown_parameters(true)).to eq(nil)
      end
    end

    it "just pass through starts_inside_quotes from ends_inside_quotes" do
      expression = parse_parameter("color")

      expect(expression.ends_inside_quotes(started_inside_quotes: true)).to eq(true)
      expect(expression.ends_inside_quotes(started_inside_quotes: false)).to eq(false)
    end
  end
end
