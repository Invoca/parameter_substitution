# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/split_after_colon'

describe ParameterSubstitution::Formatters::SplitAfterColon do
  context "Split after colon formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::SplitAfterColon
    end

    it "have a key" do
      expect(@format_class.key).to eq("split_after_colon")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Returns the portion of a string after the first colon, or nil if there is no colon.")
    end

    it "returns the part of a string after the colon" do
      expect(@format_class.format("goose:gander:gosling")).to eq("gander:gosling")
      expect(@format_class.format(123)).to eq(nil)
      expect(@format_class.format(nil)).to eq(nil)
    end

    it "strip leading whitespace after the split" do
      expect(@format_class.format("Advertiser Name: Campaign Name ")).to eq("Campaign Name ")
    end
  end
end
