# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/expression'

describe ParameterSubstitution::Expression do
  def context(text, options = {})
    context_args = {
      input: text,
      mapping: {
        "color" => "red",
        "size" => nil,
        "integer" => 1,
        "simple_text" => "hello",
        "another_simple_text" => "world"
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

    context "#evaluate" do
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

    context "#substitution_parameter_names" do
      it "return expression list parameter names" do
        expression = parse_expression("<simple_text><param_two>")
        expect(expression.substitution_parameter_names).to eq(["simple_text", "param_two"])
      end
    end

    context "#method_names" do
      it "return expression list method names" do
        expression = parse_expression("<simple_text.do_a_barrel_roll><foo.bar>")
        expect(expression.method_names).to eq(["do_a_barrel_roll", "bar"])
      end

      it "return expression list of chained method names" do
        expression = parse_expression("<simple_text.do_a_barrel_roll.again>")
        expect(expression.method_names).to eq(["do_a_barrel_roll", "again"])
      end

      it "return expression list of nested method names" do
        expression = parse_expression("<simple_text.if_nil(<another_simple_text.blank_if_nil>)>")
        expect(expression.method_names).to eq(["if_nil", "blank_if_nil"])
      end

      it "return only method names for methods with arguments" do
        expression = parse_expression("<parameter.method('arg1', 'arg2', 'arg3')>")
        expect(expression.method_names).to eq(["method"])
      end
    end

    context '#parameter_and_method_warnings' do
      let(:expression_with_valid_params) { "<color>" }
      let(:expression_with_bad_paramss) { "<bobby><bobby2>" }
      let(:expression_with_bad_methods) { "<color.test1.test2><color.test3.test4><size.test1.test2>" }
      let(:expression_with_bad_params_and_methods) { "<bobby.test1.test2><bobby2.test3.test4>" }
      let(:expression_with_mixed_bad_params_and_methods) { "<bobby.test1.test2><color.test3.test4>" }

      context "when parameters are valid" do
        it "returns nil" do
          expect(parse_expression(expression_with_valid_params).parameter_and_method_warnings)
            .to eq(nil)
        end
      end

      context "when there are invalid parameters" do
        it "returns 2 warnings" do
          expect(parse_expression(expression_with_bad_paramss).parameter_and_method_warnings).to eq(["Unknown param 'bobby'", "Unknown param 'bobby2'"])
        end
      end

      context "when there are invalid methods" do
        it "returns 2 warnings" do
          expect(parse_expression(expression_with_bad_methods).parameter_and_method_warnings)
            .to eq(["Unknown methods 'test1', 'test2', 'test3', 'test4' used on parameter 'color'",
                    "Unknown methods 'test1', 'test2' used on parameter 'size'"])
        end
      end

      context "when there are invalid parameters and methods" do
        it "returns 2 warnings" do
          expect(parse_expression(expression_with_bad_params_and_methods).parameter_and_method_warnings)
            .to eq(["Unknown param 'bobby' and methods 'test1', 'test2'", "Unknown param 'bobby2' and methods 'test3', 'test4'"])
        end
      end
    end
  end
end
