# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/greater_than_value'

describe ParameterSubstitution::Formatters::GreaterThanValue do
  context "Greater than value formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::GreaterThanValue
    end

    it "have a key" do
      expect(@format_class.key).to eq("greater_than_value")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Compares numerical values and returns results based on the comparison")
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    it "support converting durations" do
      formatter = @format_class.new(10, 1, 0)
      expect(formatter.format(0)).to eq(0)
      expect(formatter.format(10)).to eq(0)
      expect(formatter.format(11)).to eq(1)

      expect(formatter.format("10")).to eq(0)
      expect(formatter.format("11")).to eq(1)
    end

    it "support durations" do
      formatter = @format_class.new(90, 1, 0)
      expect(formatter.format("00:01:30")).to eq(0)
      expect(formatter.format("00:01:31")).to eq(1)

      expect(formatter.format("01:30")).to eq(0)
      expect(formatter.format("01:31")).to eq(1)
    end
  end
end
