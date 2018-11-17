# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/split_before_colon'

describe ParameterSubstitution::Formatters::SplitBeforeColon do
  context "Split before colon formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::SplitBeforeColon
    end

    it "have a key" do
      expect(@format_class.key).to eq("split_before_colon")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Returns the portion of a string before the first colon, or the full string if there is no colon.")
    end

    it "returns the part of a string before the colon" do
      expect(@format_class.format("goose:gander")).to eq("goose")
      expect(@format_class.format(123)).to eq("123")
      expect(@format_class.format(nil)).to eq(nil)
    end
  end
end
