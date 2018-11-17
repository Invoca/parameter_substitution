# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/split_and_find'

describe ParameterSubstitution::Formatters::SplitAndFind do
  context "Split and find formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::SplitAndFind
    end

    it "have a key" do
      expect(@format_class.key).to eq("split_and_find")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Takes delimiter and index as arguments. Splits the input on delimiters and returns the indexed element. Preserves nil.")
    end

    it "return mid characters most strings" do
      expect(@format_class.new(",", 0).format("0,1,2,3")).to eq("0")
      expect(@format_class.new(",", 1).format("0,1,2,3")).to eq("1")
      expect(@format_class.new(",", 2).format("0,1,2,3")).to eq("2")
      expect(@format_class.new(",", 3).format("0,1,2,3")).to eq("3")
      expect(@format_class.new(",", 4).format("0,1,2,3")).to eq(nil)
      expect(@format_class.new(",", -1).format("0,1,2,3")).to eq("3")
      expect(@format_class.new("..", 1).format("0..1..2..3")).to eq("1")
      expect(@format_class.new(",", 0).format("nodelimiter")).to eq("nodelimiter")
      expect(@format_class.new(",", 0).format(nil)).to eq(nil)
      expect(@format_class.new(",", 0).format(12345678)).to eq("12345678")
    end
  end
end
