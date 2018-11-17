# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/trim'

describe ParameterSubstitution::Formatters::Trim do
  context "Trim formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Trim
    end

    it "have a key" do
      expect(@format_class.key).to eq("trim")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Returns the input as a string with leading and trailing whitespace removed.")
    end

    it "return left most strings" do
      expect(@format_class.format(" nospaces ")).to eq("nospaces")
      expect(@format_class.format("nospaces")).to eq("nospaces")
      expect(@format_class.format("middle spaces")).to eq("middle spaces")

      expect(@format_class.format(nil)).to eq(nil)
      expect(@format_class.format(12345678)).to eq("12345678")
    end
  end
end
