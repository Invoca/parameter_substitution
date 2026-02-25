# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/dollars_to_cents'

describe ParameterSubstitution::Formatters::DollarsToCents do
  context "DollarsToCents formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DollarsToCents
    end

    it "have a key" do
      expect(@format_class.key).to eq("dollars_to_cents")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts a dollar amount to cents as an integer")
    end

    it "converts valid string dollar amounts to cents" do
      expect(@format_class.format("10.50")).to eq(1050)
      expect(@format_class.format("10")).to eq(1000)
      expect(@format_class.format("0.01")).to eq(1)
      expect(@format_class.format("123.456")).to eq(12346)
      expect(@format_class.format("0.001")).to eq(0)
      expect(@format_class.format("100")).to eq(10000)
      expect(@format_class.format("99.99")).to eq(9999)
      expect(@format_class.format("-10.50")).to eq(-1050)
    end

    it "converts valid numeric dollar amounts to cents" do
      expect(@format_class.format(10.50)).to eq(1050)
      expect(@format_class.format(10)).to eq(1000)
      expect(@format_class.format(0.01)).to eq(1)
      expect(@format_class.format(123.456)).to eq(12346)
      expect(@format_class.format(0.001)).to eq(0)
      expect(@format_class.format(100)).to eq(10000)
      expect(@format_class.format(99.99)).to eq(9999)
      expect(@format_class.format(-10.50)).to eq(-1050)
    end

    it "returns nil for nil or invalid strings" do
      expect(@format_class.format(nil)).to eq(nil)
      expect(@format_class.format("")).to eq(nil)
      expect(@format_class.format("$10.50")).to eq(nil)
      expect(@format_class.format("not_a_number")).to eq(nil)
    end
  end
end
