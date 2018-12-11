# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/downcase'

describe ParameterSubstitution::Formatters::Downcase do
  context "Downcase formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Downcase
    end

    it "have a key" do
      expect(@format_class.key).to eq("downcase")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts to string and downcases the values, preserves nil.")
    end

    it "converts to downcase" do
      expect(@format_class.format("THIS IS ALL LOWER")).to eq("this is all lower")
      expect(@format_class.format(123)).to eq("123")
      expect(@format_class.format(nil)).to eq(nil)
    end
  end
end
