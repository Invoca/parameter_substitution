# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/json_parse'

describe ParameterSubstitution::Formatters::JsonParse do
  context "Json parse formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::JsonParse
    end

    it "have a key" do
      expect(@format_class.key).to eq("json_parse")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Attempts to parse strings as JSON. If valid, passes along the parsed object, if not valid json, or not a string, passes the json encoded value.")
    end

    it "report json as an encoding" do
      expect(@format_class.encoding).to eq(:json)
    end

    it "pass along the value if it is valid json" do
      expect(@format_class.format('{ "cats": "crazy" }')).to eq('{ "cats": "crazy" }')
      expect(@format_class.format('["cats", "crazy"]')).to eq('["cats", "crazy"]')
      expect(@format_class.format('[null]')).to eq('[null]')
    end

    it "quote and json encode non-json strings" do
      expect(@format_class.format('invalid json')).to eq('"invalid json"')
    end

    it "encode non-string values" do
      expect(@format_class.format(nil)).to eq("null")
      expect(@format_class.format(11)).to eq("11")
    end
  end
end
