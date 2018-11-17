# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/lower'

describe ParameterSubstitution::Formatters::Lower do
  context "Lower formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Lower
    end

    it "have a key" do
      expect(@format_class.key).to eq("lower")
    end

    it "provides a description" do
      expect(@format_class.description).to eq("Converts to string and returns all characters lowercased, preserves nil.")
    end

    it "returns lower cased strings" do
      expect(@format_class.format("LoWerCased")).to eq("lowercased")
      expect(@format_class.format("lowercased")).to eq("lowercased")

      expect(@format_class.format(nil)).to eq(nil)
      expect(@format_class.format(12345678)).to eq("12345678")
    end
  end
end
