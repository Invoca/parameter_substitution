# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/mid'

describe ParameterSubstitution::Formatters::Mid do
  context "Mid formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Mid
    end

    it "have a key" do
      expect(@format_class.key).to eq("mid")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Takes starting_position and character_count as arguments. Returns the character_count characters starting from starting_position from the input.")
    end

    it "return mid characters most strings" do
      expect(@format_class.new(2, 2).format("abcdefg")).to eq("cd")
      expect(@format_class.new(0, 2).format("abcdefg")).to eq("ab")
      expect(@format_class.new(1, 5).format("abcdefg")).to eq("bcdef")
      expect(@format_class.new(0, 3).format("abc")).to eq("abc")
      expect(@format_class.new(0, 3).format("ab")).to eq("ab")
      expect(@format_class.new(1, 3).format(nil)).to eq(nil)
      expect(@format_class.new(1, 3).format(12345678)).to eq("234")
    end
  end
end
