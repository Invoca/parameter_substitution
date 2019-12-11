# frozen_string_literal: true

require_relative '../../lib/parameter_substitution'

describe ParameterSubstitution do
  def default_mapping
    {
      'foo' => 'Bar',
      'black' => 'white',
      'integer' => 123,
      'has nonsense . < >' => 'Worked!'
    }
  end

  def assert_parse_error(expected_error, input)
    _result, error = ParameterSubstitution.evaluate(input: input, mapping: @mapping)
    expect(error).to eq(expected_error), "on line #{caller(2..2)}"
  end

  def assert_parse_result(expected_result, input, options = {})
    result, error = ParameterSubstitution.evaluate(**{ input: input, mapping: @mapping }.merge(options))
    expect(error).to be_nil
    expect(result).to eq(expected_result), "on line #{caller(2..2)}"
  end

  context "configuration" do
    before :all do
      class DumbClass
      end

      class SmartClass < ParameterSubstitution::Formatters::Base
        def self.find(_key); end
      end
    end

    it "throw error if custom formatters do not have the correct superclass" do
      ParameterSubstitution.configure do |config|
        exception_expectations = [
          StandardError,
          "CONFIGURATION ERROR: custom_formatters (dumb_class: DumbClass) must inherit from ParameterSubstitution::Formatters::Base and did not."
        ]

        expect do
          config.custom_formatters = { "dumb_class" => DumbClass, "smart_class" => SmartClass }
        end.to raise_exception(*exception_expectations)
      end
    end

    it "checks that custom formatters are of the correct type" do
      ParameterSubstitution.configure do |config|
        exception_expectations = [
          StandardError,
          "CONFIGURATION ERROR: custom_formatters (dumb_class: DumbClass) must be of type Class."
        ]

        expect do
          config.custom_formatters = { "dumb_class" => "DumbClass", "smart_class" => SmartClass }
        end.to raise_exception(*exception_expectations)
      end
    end
  end

  context "parameter expression" do
    before do
      @mapping = {
        'foo' => 'Bar',
        'black' => 'white',
        'integer' => 123
      }
    end

    context "parsing helpers" do
      let(:expression) { "<call.start_time.blank_if_nil><do_a_barrel_roll.downcase>" }
      let(:mapping) { { 'call.start_time' => 'hello' } }

      context "#find_tokens" do
        it "returns tokens up to first dot when no mapping is provided" do
          expect(ParameterSubstitution.find_tokens(expression)).to eq(['call', 'do_a_barrel_roll'])
        end

        it "returns tokens that exist in mapping when one is provided" do
          expect(ParameterSubstitution.find_tokens(expression, mapping: mapping)).to eq(['call.start_time', 'do_a_barrel_roll'])
        end
      end

      context '#find_formatters' do
        it "returns all formatters after first dot when no mapping is provided" do
          expect(ParameterSubstitution.find_formatters(expression)).to eq(['start_time', 'blank_if_nil', 'downcase'])
        end

        it "returns formatters after all tokens when mapping is provided" do
          expect(ParameterSubstitution.find_formatters(expression, mapping: mapping)).to eq(['blank_if_nil', 'downcase'])
        end
      end

      context '#find_warnings' do
        let(:expression_with_valid_params) { "<foo>" }
        let(:expression_with_bad_paramss) { "<bobby><bobby2>" }
        let(:expression_with_bad_methods) { "<foo.test1.test2><foo.test3.test4><black.test1.test2>" }
        let(:expression_with_bad_params_and_methods) { "<bobby.test1.test2><bobby2.test3.test4>" }
        let(:expression_with_mixed_bad_params_and_methods) { "<bobby.test1.test2><foo.test3.test4>" }

        context "when parameters are valid" do
          it "returns empty array" do
            expect(ParameterSubstitution.find_warnings(expression_with_valid_params, mapping: default_mapping))
              .to eq([])
          end
        end

        context "when warning_type is :unknown_param_warning_type" do
          it "returns 1 warnings" do
            expect(ParameterSubstitution.find_warnings(expression_with_mixed_bad_params_and_methods,
                                                       mapping: default_mapping, warning_type: :unknown_param_warning_type))
              .to eq(["Unknown param 'bobby' and methods 'test1', 'test2'"])
          end
        end

        context "when warning_type is :unknown_method_warning_type" do
          it "returns 1 warning" do
            expect(ParameterSubstitution.find_warnings(expression_with_mixed_bad_params_and_methods,
                                                       mapping: default_mapping, warning_type: :unknown_method_warning_type))
              .to eq(["Unknown methods 'test3', 'test4' used on parameter 'foo'"])
          end
        end

        context "when there are invalid parameters" do
          it "returns 2 warnings" do
            expect(ParameterSubstitution.find_warnings(expression_with_bad_paramss)).to eq(["Unknown param 'bobby'", "Unknown param 'bobby2'"])
          end
        end

        context "when there are invalid methods" do
          it "returns 2 warnings" do
            expect(ParameterSubstitution.find_warnings(expression_with_bad_methods, mapping: default_mapping))
              .to eq(["Unknown methods 'test1', 'test2', 'test3', 'test4' used on parameter 'foo'",
                      "Unknown methods 'test1', 'test2' used on parameter 'black'"])
          end
        end

        context "when there are invalid parameters and methods" do
          it "returns 2 warnings" do
            expect(ParameterSubstitution.find_warnings(expression_with_bad_params_and_methods))
              .to eq(["Unknown param 'bobby' and methods 'test1', 'test2'", "Unknown param 'bobby2' and methods 'test3', 'test4'"])
          end
        end
      end
    end

    it "handle simple go right cases" do
      assert_parse_result ".bar.", ".<foo.downcase>."
      assert_parse_result ".bar.", ".<foo.downcase()>."
    end

    it "work with escaped parameter names" do
      @mapping['has nonsense . <>'] = 'Worked!'
      # Escaping slashes gets hard to read, so being verbose in favor of clarity.
      slash = "\\"

      assert_parse_result ".Worked!.", ".<has#{slash} nonsense#{slash} #{slash}.#{slash} #{slash}<#{slash}>>."
    end

    it "resolve missing methods if they match to a mapping" do
      assert_parse_result ".bar.", ".<call.transaction_id>.", mapping: { 'call.transaction_id' => 'bar' }
    end

    context "encodings" do
      it "preserve the data type when the encoding is raw" do
        assert_parse_result 123, "<integer>", destination_encoding: :raw
        assert_parse_result ".123.", ".<integer>.", destination_encoding: :raw
        assert_parse_result "123", "<integer.downcase>", destination_encoding: :raw
      end

      it "convert to string when the encoding is text" do
        assert_parse_result "123", "<integer>", destination_encoding: :text
      end

      it "allow json parsed values to be passed" do
        @mapping = { 'axiom' => '{ "cats": "crazy" }' }
        assert_parse_result '{ "cats": "crazy" }', "<axiom.json_parse>", destination_encoding: :json
      end

      it "allow pass along " do
        @mapping = { 'axiom' => '{ "cats": "crazy" }' }
        assert_parse_result '{ "cats": "crazy" }', "<axiom.json_parse>", destination_encoding: :json
      end
    end

    context "error handling" do
      it "report unbalanced brackets" do
        assert_parse_error "Missing '<' before '>'", "abc>"
        assert_parse_error "Missing '<' before '>'", "<abc>>"
        assert_parse_error "Missing '>' after '<'", "<abc"
        assert_parse_error "Missing '>' after '<'", "<abc><"
      end

      it "report unknown tokens" do
        assert_parse_error "Unknown replacement parameter 'abc'", "<abc>"
      end

      it "report invalid methods" do
        assert_parse_error "Unknown method 'not_a_format'", "<foo.not_a_format>"
        assert_parse_error "Wrong number of arguments for 'downcase' expected 0, received 1", "<foo.downcase(1)>"
        assert_parse_error "Wrong number of arguments for 'compare_string' expected 3, received 0", "<foo.compare_string>"
        assert_parse_error "Wrong number of arguments for 'compare_string' expected 3, received 1", "<foo.compare_string(1)>"
      end
    end
  end
end
