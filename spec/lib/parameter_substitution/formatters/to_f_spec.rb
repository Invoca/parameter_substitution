# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/to_f'

describe ParameterSubstitution::Formatters::ToF do
  context "ToF formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::ToF
    end

    it "have a key" do
      expect(@format_class.key).to eq("to_f")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts a string to a double-precision floating point number")
    end

    it "converts valid string to float rounded to 2 decimal places" do
      expect(@format_class.format("123.456")).to eq(123.46)
      expect(@format_class.format("0.001")).to eq(0.00)
      expect(@format_class.format("-9876.54321")).to eq(-9876.54)
      expect(@format_class.format("123")).to eq(123.0)
      expect(@format_class.format("123.4")).to eq(123.4)
    end

    it "returns nil for nil or invalid strings" do
      expect(@format_class.format(nil)).to eq(nil)
      expect(@format_class.format("")).to eq(nil)
      expect(@format_class.format("$123.4")).to eq(nil)
      expect(@format_class.format("not_a_number")).to eq(nil)
    end
  end
end