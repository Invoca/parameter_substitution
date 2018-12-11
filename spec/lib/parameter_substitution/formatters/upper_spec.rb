# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/upper'

describe ParameterSubstitution::Formatters::Upper do
  context "Upper formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Upper
    end

    it "have a key" do
      expect(@format_class.key).to eq("upper")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts to string and returns all characters uppercased, preserves nil.")
    end

    it "return upper cased strings" do
      expect(@format_class.format("uppeRCased")).to eq("UPPERCASED")
      expect(@format_class.format("UPPERCASED")).to eq("UPPERCASED")

      expect(@format_class.format(nil)).to eq(nil)
      expect(@format_class.format(12345678)).to eq("12345678")
    end
  end
end
