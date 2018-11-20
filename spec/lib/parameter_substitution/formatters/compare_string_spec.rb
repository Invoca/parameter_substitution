# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/compare_string'

describe ParameterSubstitution::Formatters::CompareString do
  context "format test" do
    before do
      @format_class = ParameterSubstitution::Formatters::CompareString
      @formatter    = @format_class.new("1", "true value", "false value")
    end

    it "have a key" do
      expect(@format_class.key).to eq("compare_string")
    end

    it "provide a description" do
      expected = "Compares the field to a string and returns results based on the comparison"
      expect(@format_class.description).to eq(expected)
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to be(true)
    end

    it "return true value if the string matches, false value if it does not" do
      expect(@formatter.format("1")).to eq("true value")
      expect(@formatter.format("something else")).to eq("false value")
    end

    it "ensure compare value is a string prior to comparison" do
      expect(@formatter.format(1)).to eq("true value")
      expect(@formatter.format(nil)).to eq("false value")
    end
  end
end
