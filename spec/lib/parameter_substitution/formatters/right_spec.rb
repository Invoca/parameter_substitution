# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/right'

describe ParameterSubstitution::Formatters::Right do
  context "Right formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Right
    end

    it "have a key" do
      expect(@format_class.key).to eq("right")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Takes a single n argument. Returns the right most n characters from the input.")
    end

    it "return left most strings" do
      expect(@format_class.new(3).format("abcdefg")).to eq("efg")
      expect(@format_class.new(3).format("abc")).to eq("abc")
      expect(@format_class.new(3).format("ab")).to eq("ab")

      expect(@format_class.new(3).format(nil)).to eq("")
      expect(@format_class.new(3).format(12345678)).to eq("678")
    end
  end
end
