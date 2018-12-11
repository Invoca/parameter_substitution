# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/method_call_expression'

describe ParameterSubstitution::MethodCallExpression do
  def parse_method_call(format_expression)
    parser    = ParameterSubstitution::Parser.new
    transform = ParameterSubstitution::Transform.new(:cgi)
    transform.apply(parser.method_call.parse(format_expression))
  end

  context "MethodCallExpression" do
    it "be constructable" do
      expression = parse_method_call("substring(1,3)")

      expect("substring").to eq(expression.name)
      expect([1, 3]).to eq(expression.arguments)
    end

    it "be able to call methods without arguments" do
      expression = parse_method_call("downcase")
      expect("mixed_case").to eq(expression.call_method("MiXeD_CaSE"))
    end

    it "be able to call methods with arguments" do
      expression = parse_method_call('add_prefix("cheese")')
      expect("cheese and crackers").to eq(expression.call_method(" and crackers"))
    end

    context "validate" do
      it "report unknown methods" do
        expression = parse_method_call('not_a_method("cheese")')
        expect { expression.validate }.to raise_exception(ParameterSubstitution::ParseError, "Unknown method 'not_a_method'")
      end

      it "report report when a method with no arguments is called with arguments" do
        expression = parse_method_call('downcase("cheese")')
        expect { expression.validate }.to raise_exception(
          ParameterSubstitution::ParseError,
          "Wrong number of arguments for 'downcase' expected 0, received 1"
        )
      end

      it "report report when a method with arguments is called with no arguments" do
        expression = parse_method_call('compare_string')
        expect { expression.validate }.to raise_exception(
          ParameterSubstitution::ParseError,
          "Wrong number of arguments for 'compare_string' expected 3, received 0"
        )
      end
    end
  end
end
