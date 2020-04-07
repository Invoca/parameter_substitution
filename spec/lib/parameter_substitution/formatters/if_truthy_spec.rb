# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/if_truthy'

describe ParameterSubstitution::Formatters::IfTruthy do
  context "If nil formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::IfTruthy
    end

    it "have a key" do
      expect(@format_class.key).to eq("if_truthy")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("The input is truthy (i.e. true, 1, y, YES) then the input is replaced with the first argument. Otherwise, the input is replaced with the second argument.")
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    it "return true string when value is truthy" do
      instance = @format_class.new("correct", "incorrect")
      expect(instance.format(true)).to eq("correct")
      expect(instance.format("true")).to eq("correct")
      expect(instance.format("TRUE")).to eq("correct")
      expect(instance.format(1)).to eq("correct")
      expect(instance.format("1")).to eq("correct")
      expect(instance.format("Y")).to eq("correct")
      expect(instance.format("YES")).to eq("correct")
      expect(instance.format("y")).to eq("correct")
      expect(instance.format("yes")).to eq("correct")
    end

    it "return false string when value is not truthy" do
      instance = @format_class.new("incorrect", "correct")
      expect(instance.format(false)).to eq("correct")
      expect(instance.format("false")).to eq("correct")
      expect(instance.format("FALSE")).to eq("correct")
      expect(instance.format(0)).to eq("correct")
      expect(instance.format("0")).to eq("correct")
      expect(instance.format("N")).to eq("correct")
      expect(instance.format("NO")).to eq("correct")
      expect(instance.format("n")).to eq("correct")
      expect(instance.format("no")).to eq("correct")
      expect(instance.format(nil)).to eq("correct")
      expect(instance.format("")).to eq("correct")
      expect(instance.format(1234)).to eq("correct")
      expect(instance.format("random string")).to eq("correct")
    end
  end
end
