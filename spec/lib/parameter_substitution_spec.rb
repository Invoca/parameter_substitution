# frozen_string_literal: true

require_relative '../../lib/parameter_substitution'

describe ParameterSubstitution do
  def default_mapping
    {
      'foo'                => 'Bar',
      'black'              => 'white',
      'integer'            => 123,
      'has nonsense . < >' => 'Worked!'
    }
  end

  def assert_parse_error(expected_error, input)
    _result, error = ParameterSubstitution.evaluate(input: input, mapping: @mapping)
    expect(error).to eq(expected_error), "on line #{caller(2..2)}"
  end

  def assert_parse_result(expected_result, input, options = {})
    result, error = ParameterSubstitution.evaluate(**({ input: input, mapping: @mapping }.merge(options)))
    expect(error).to be_nil
    expect(result).to eq(expected_result), "on line #{caller(2..2)}"
  end

  before do
    ParameterSubstitution.configure do |config|
      config.method_call_base_class = TestFormatterBase
    end
  end

  context "configuration" do
    it "throw error if configured base class has no find method" do
      class DumbClass
      end

      ParameterSubstitution.configure do |config|
        expect do
          config.method_call_base_class = DumbClass
        end.to raise_exception(StandardError, /CONFIGURATION ERROR: base_class DumbClass must have a find method/)
        # TODO: Confirm namespace and error class differences are okay
      end
    end

    it "should store reference to base class and be able to call its find method" do
      class SmartClass
        def self.find(name)
          name
        end
      end

      ParameterSubstitution.configure do |config|
        config.method_call_base_class = SmartClass
      end

      expect(ParameterSubstitution.config.method_call_base_class.find('name')).to eq('name')
    end
  end

  context "parameter expression" do
    before do
      @mapping = {
        'foo'     => 'Bar',
        'black'   => 'white',
        'integer' => 123
      }
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
